//
//  BillingAddressView.swift
//  JungleHotel
//
//  Created by TS2 on 11/25/25.
//

import SwiftUI

struct BillingAddressView: View {
    @StateObject private var apiService = CountryStateCityService()
    
    @State private var selectedCountryCode: String? // Country.iso2
    @State private var selectedStateCode: String? // StateModel.state_code
    @State private var selectedCityName: String? // City.name
    @State private var userName: String = ""
    
    private var selectedCountryModel: Country? {
        guard let code = selectedCountryCode else { return nil }
        return apiService.countries.first { $0.iso2 == code }
    }

    private var selectedStateModel: StateModel? {
        guard let code = selectedStateCode else { return nil }
        return apiService.states.first { $0.iso2 == code }
    }

    private var selectedCityModel: City? {
        guard let name = selectedCityName else { return nil }
        return apiService.cities.first { $0.name == name }
    }
    
    @State private var address: String = ""
    @State private var zipCode: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Billing Address")
                .font(.title3)
                .bold()
            
            // Local bindings to reduce type-checking complexity
            let countrySelection = Binding<String?>(
                get: { selectedCountryCode },
                set: { selectedCountryCode = $0 }
            )
            let stateSelection = Binding<String?>(
                get: { selectedStateCode },
                set: { selectedStateCode = $0 }
            )
            let citySelection = Binding<String?>(
                get: { selectedCityName },
                set: { selectedCityName = $0 }
            )
            
            InputCompView(
                textLabel: "Name",
                textValue: $userName,
                placeholder: "Enter full name",
                keyboardType: .default,
                icon: "person"
            )
            // Country Picker
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 2) {
                    Text("Country").font(.subheadline)
                    Text("*").foregroundStyle(.red)
                }

                Picker("Country", selection: countrySelection) {
                    Text("Select Country").tag(nil as String?)
                    ForEach(apiService.countries) { country in
                        Text(country.name).tag(country.iso2 as String?)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: selectedCountryCode) { oldValue, newValue in
                    selectedStateCode = nil
                    selectedCityName = nil
                    if let code = newValue {
                        Task { await apiService.fetchStates(for: code) }
                    } else {
                        apiService.states = []
                        apiService.cities = []
                    }
                }
            }
            
            // Address Input
            InputCompView(
                textLabel: "Address",
                textValue: $address,
                placeholder: "Enter street address",
                keyboardType: .default
            )
            
            // State Picker
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 2) {
                    Text("State/Province").font(.subheadline)
                    Text("*").foregroundStyle(.red)
                }

                if selectedCountryCode != nil && apiService.states.isEmpty && !apiService.isLoading {
                    // Show text field if no states available
                    TextField("Enter state/province", text: Binding<String>(
                        get: { selectedStateCode ?? "" },
                        set: { value in selectedStateCode = value.isEmpty ? nil : value }
                    ))
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 12)
                    .frame(height: 45)
                    .background(Color.gray.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .cornerRadius(10)
                } else {
                    Picker("State", selection: stateSelection) {
                        Text("Select State").tag(nil as String?)
                        ForEach(apiService.states) { state in
                            Text(state.name).tag(state.iso2 as String?)
                        }
                    }
                    .pickerStyle(.menu)
                    .disabled(selectedCountryCode == nil || apiService.states.isEmpty)
                    .onChange(of: selectedStateCode) { oldValue, newValue in
                        selectedCityName = nil
                        if let stateCode = newValue, let countryCode = selectedCountryCode {
                            Task { await apiService.fetchCities(for: countryCode, stateCode: stateCode) }
                        } else {
                            apiService.cities = []
                        }
                    }
                }
            }
            
            // City Picker
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 2) {
                    Text("City").font(.subheadline)
                    Text("*").foregroundStyle(.red)
                }

                if selectedStateCode != nil && apiService.cities.isEmpty && !apiService.isLoading {
                    // Show text field if no cities available
                    TextField("Enter city", text: Binding<String>(
                        get: { selectedCityName ?? "" },
                        set: { value in selectedCityName = value.isEmpty ? nil : value }
                    ))
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 12)
                    .frame(height: 45)
                    .background(Color.gray.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .cornerRadius(10)
                } else {
                    Picker("City", selection: citySelection) {
                        Text("Select City").tag(nil as String?)
                        ForEach(apiService.cities) { city in
                            Text(city.name).tag(city.name as String?)
                        }
                    }
                    .pickerStyle(.menu)
                    .disabled(selectedStateCode == nil || apiService.cities.isEmpty)
                }
            }
            
            // Zip/Postal Code Input
            InputCompView(
                textLabel: "Zip/Postal Code",
                textValue: $zipCode,
                placeholder: "Enter zip/postal code",
                keyboardType: .numbersAndPunctuation
            )
            
            // Loading Indicator
            if apiService.isLoading {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Text("Loading...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Error Message
            if !apiService.errorMessage.isEmpty {
                Text(apiService.errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding(20)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        .cornerRadius(10)
        .task {
            // Fetch countries when view appears
            await apiService.fetchCountries()
        }
    }
}

#Preview {
    ScrollView {
        BillingAddressView()
            .padding()
    }
}

