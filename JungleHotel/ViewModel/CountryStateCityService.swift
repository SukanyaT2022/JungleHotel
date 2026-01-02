//
//  CountryStateCityService.swift
//  JungleHotel
//
//  Created by TS2 on 12/9/25.
//

import Foundation

// MARK: - Models
// Models.swift
import Foundation

struct Country: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let iso2: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case iso2
    }
}

struct StateModel: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let iso2: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case iso2
    }
}

struct City: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
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

