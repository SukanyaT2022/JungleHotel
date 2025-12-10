//
//  CountryStateCityService.swift
//  JungleHotel
//
//  Created by TS2 on 12/9/25.
//

import Foundation

// MARK: - Models
struct Country: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let iso2: String
    let iso3: String?
    let phonecode: String?
    let capital: String?
    let currency: String?
    let currency_name: String?
    let currency_symbol: String?
    let region: String?
    let subregion: String?
}

struct StateModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let state_code: String // This is the iso2 code from API
    let country_code: String? // Not in API response, will be set manually
    let country_name: String?
    let type: String?
    let latitude: String?
    let longitude: String?
    
    // Custom coding keys - API uses "iso2" for state code
    enum CodingKeys: String, CodingKey {
        case id, name
        case state_code = "iso2" // Map iso2 to state_code
        case country_name
        case type
        case latitude
        case longitude
    }
    
    // Custom decoder to handle the API structure
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        state_code = try container.decode(String.self, forKey: .state_code) // iso2
        country_code = nil // Not provided by API
        country_name = try? container.decode(String.self, forKey: .country_name)
        type = try? container.decode(String.self, forKey: .type)
        latitude = try? container.decode(String.self, forKey: .latitude)
        longitude = try? container.decode(String.self, forKey: .longitude)
    }
}

struct City: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let country_code: String?
    let state_code: String?
    let country_name: String?
    let state_name: String?
    let latitude: String?
    let longitude: String?
    
    // Custom decoder to handle missing or null values gracefully
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        country_code = try? container.decode(String.self, forKey: .country_code)
        state_code = try? container.decode(String.self, forKey: .state_code)
        country_name = try? container.decode(String.self, forKey: .country_name)
        state_name = try? container.decode(String.self, forKey: .state_name)
        latitude = try? container.decode(String.self, forKey: .latitude)
        longitude = try? container.decode(String.self, forKey: .longitude)
    }
}

// MARK: - Country State City Service
@MainActor
class CountryStateCityService: ObservableObject {
    @Published var countries: [Country] = []
    @Published var states: [StateModel] = []
    @Published var cities: [City] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let apiKey = "cnZrTGRpaEJyZmlnc21qc2V2bGpuRHRDYnRZZEhRaFFGT1hxaGNuTg=="
    private let baseURL = "https://api.countrystatecity.in/v1"
    
    // MARK: - Fetch Countries all countries
    func fetchCountries() async {
        isLoading = true
        errorMessage = ""
        
        guard let url = URL(string: "\(baseURL)/countries") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-CSCAPI-KEY")
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Invalid response"
                isLoading = false
                return
            }
            
            if httpResponse.statusCode == 200 {
                let decodedCountries = try JSONDecoder().decode([Country].self, from: data)
                self.countries = decodedCountries.sorted { $0.name < $1.name }
                print("✅ Fetched \(decodedCountries.count) countries")
            } else {
                errorMessage = "Failed to fetch countries. Status code: \(httpResponse.statusCode)"
                print("❌ Error: \(errorMessage)")
            }
        } catch {
            errorMessage = "Error fetching countries: \(error.localizedDescription)"
            print("❌ Error: \(errorMessage)")
        }
        
        isLoading = false
    }
    
    // MARK: - Fetch States by Country
    func fetchStates(for countryCode: String) async {
        isLoading = true
        errorMessage = ""
        states = [] // Clear previous states
        cities = [] // Clear cities when country changes
        
        guard let url = URL(string: "\(baseURL)/countries/\(countryCode)/states") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-CSCAPI-KEY")
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Invalid response"
                isLoading = false
                return
            }
            
            if httpResponse.statusCode == 200 {
                // Debug: Print raw response
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📥 States API Response: \(jsonString.prefix(500))")
                }
                
                let decodedStates = try JSONDecoder().decode([StateModel].self, from: data)
                self.states = decodedStates.sorted { $0.name < $1.name }
                print("✅ Fetched \(decodedStates.count) states for \(countryCode)")
            } else if httpResponse.statusCode == 404 {
                // No states found for this country
                self.states = []
                errorMessage = "No states available for this country"
                print("⚠️ No states found for \(countryCode)")
            } else {
                errorMessage = "Failed to fetch states. Status code: \(httpResponse.statusCode)"
                print("❌ Error: \(errorMessage)")
            }
        } catch let DecodingError.keyNotFound(key, context) {
            errorMessage = "Missing key '\(key.stringValue)' in response"
            print("❌ Decoding Error - Missing key: \(key.stringValue)")
            print("   Context: \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(type, context) {
            errorMessage = "Type mismatch for type \(type)"
            print("❌ Decoding Error - Type mismatch: \(type)")
            print("   Context: \(context.debugDescription)")
        } catch let DecodingError.valueNotFound(type, context) {
            errorMessage = "Value not found for type \(type)"
            print("❌ Decoding Error - Value not found: \(type)")
            print("   Context: \(context.debugDescription)")
        } catch {
            errorMessage = "Error fetching states: \(error.localizedDescription)"
            print("❌ Error: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Fetch Cities by Country and State
    func fetchCities(for countryCode: String, stateCode: String) async {
        isLoading = true
        errorMessage = ""
        cities = [] // Clear previous cities
        
        guard let url = URL(string: "\(baseURL)/countries/\(countryCode)/states/\(stateCode)/cities") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-CSCAPI-KEY")
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Invalid response"
                isLoading = false
                return
            }
            
            if httpResponse.statusCode == 200 {
                // Debug: Print raw response
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📥 Cities API Response: \(jsonString.prefix(500))")
                }
                
                let decodedCities = try JSONDecoder().decode([City].self, from: data)
                self.cities = decodedCities.sorted { $0.name < $1.name }
                print("✅ Fetched \(decodedCities.count) cities for \(countryCode)/\(stateCode)")
            } else if httpResponse.statusCode == 404 {
                // No cities found
                self.cities = []
                errorMessage = "No cities available for this state"
                print("⚠️ No cities found for \(countryCode)/\(stateCode)")
            } else {
                errorMessage = "Failed to fetch cities. Status code: \(httpResponse.statusCode)"
                print("❌ Error: \(errorMessage)")
            }
        } catch let DecodingError.keyNotFound(key, context) {
            errorMessage = "Missing key '\(key.stringValue)' in response"
            print("❌ Decoding Error - Missing key: \(key.stringValue)")
            print("   Context: \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(type, context) {
            errorMessage = "Type mismatch for type \(type)"
            print("❌ Decoding Error - Type mismatch: \(type)")
            print("   Context: \(context.debugDescription)")
        } catch let DecodingError.valueNotFound(type, context) {
            errorMessage = "Value not found for type \(type)"
            print("❌ Decoding Error - Value not found: \(type)")
            print("   Context: \(context.debugDescription)")
        } catch {
            errorMessage = "Error fetching cities: \(error.localizedDescription)"
            print("❌ Error: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Reset Data
    func reset() {
        countries = []
        states = []
        cities = []
        errorMessage = ""
    }
}

