//
//  HotelViewModel.swift
//  JungleHotel
//
//  Created by TS2 on 8/29/25.
//

import Foundation
import Combine
import FirebaseFirestore
import SwiftData

// MARK: - Hotel View Model
@MainActor
class HotelViewModel: ObservableObject {
    @Published var hotels: [HotelModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let firestoreManager = FirestoreManager()
    private var listener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        setupRealtimeListener()
        
        // Fallback: If no data comes from listener within 5 seconds, try manual fetch
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            if self?.hotels.isEmpty == true && self?.isLoading == true {
                print("⏰ HotelViewModel: Listener timeout, trying manual fetch as fallback")
                self?.fetchHotels()
            }
        }
    }
    
    // MARK: - Fetch Hotels
    func fetchHotels() {
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                let fetchedHotels = try await firestoreManager.fetchHotels()
                await MainActor.run {
                    self.hotels = fetchedHotels
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to fetch hotels: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    // MARK: - Setup Real-time Listener
    func setupRealtimeListener() {
        print("🔄 HotelViewModel: Setting up real-time listener...")
        isLoading = true
        listener = firestoreManager.fetchHotelsWithListener { [weak self] hotels in
            DispatchQueue.main.async {
                print("📱 HotelViewModel: Received \(hotels.count) hotels from listener")
                self?.hotels = hotels
                self?.isLoading = false
                
                // Clear any error message when we get data
                if !hotels.isEmpty {
                    self?.errorMessage = ""
                    print("✅ HotelViewModel: Successfully updated with \(hotels.count) hotels")
                } else {
                    print("⚠️ HotelViewModel: Received empty hotels array")
                }
            }
        }
    }
    
    // MARK: - Get All Rooms
    var allRooms: [Room] {
        return hotels.flatMap { $0.roomObj }
    }
    
    // MARK: - Filter Available Rooms
    var availableRooms: [Room] {
        return allRooms.filter { $0.roomAvailbility.lowercased() == "available" }
    }
    
    // MARK: - Get Rooms by Hotel
    func getRooms(for hotel: HotelModel) -> [Room] {
        return hotel.roomObj
    }
    
    // MARK: - Get Available Rooms by Hotel
    func getAvailableRooms(for hotel: HotelModel) -> [Room] {
        return hotel.roomObj.filter { $0.roomAvailbility.lowercased() == "available" }
    }
    
    // MARK: - Search Hotels
    func searchHotels(with query: String) -> [HotelModel] {
        if query.isEmpty {
            return hotels
        }
        
        let lowercasedQuery = query.lowercased()
        
        return hotels.compactMap { hotel in
            // Check if hotel name matches
            let hotelNameMatches = hotel.hotelNameType.lowercased().contains(lowercasedQuery)
            
            // Filter rooms that match the search query
            let matchingRooms = hotel.roomObj.filter { room in
                room.roomName.lowercased().contains(lowercasedQuery) ||
                room.roomDetail.lowercased().contains(lowercasedQuery)
            }
            
            // If hotel name matches, return all rooms
            if hotelNameMatches {
                return hotel
            }
            
            // If no hotel name match but rooms match, return hotel with only matching rooms
            if !matchingRooms.isEmpty {
            return HotelModel(
                id: hotel.id,
                hotelNameType: hotel.hotelNameType,
                latitude: hotel.latitude,
                longitude: hotel.longitude,
                contactNumber: hotel.contactNumber,
                address: hotel.address,
                roomObj: matchingRooms
            )
            }
            
            // No matches found
            return nil
        }
    }
    
    // MARK: - Filter by Price Range
    func filterHotels(minPrice: Int, maxPrice: Int) -> [HotelModel] {
        return hotels.compactMap { hotel in
            let filteredRooms = hotel.roomObj.filter { room in
                room.roomPrice >= minPrice && room.roomPrice <= maxPrice
            }
            
            if filteredRooms.isEmpty {
                return nil
            }
            
            return HotelModel(
                id: hotel.id,
                hotelNameType: hotel.hotelNameType,
                latitude: hotel.latitude,
                longitude: hotel.longitude,
                contactNumber: hotel.contactNumber,
                address: hotel.address,
                roomObj: filteredRooms
            )
        }
    }
    
    // MARK: - Sort Hotels by Price
    func sortHotelsByPrice(ascending: Bool = true) -> [HotelModel] {
        return hotels.map { hotel in
            let sortedRooms = hotel.roomObj.sorted { room1, room2 in
                ascending ? room1.roomPrice < room2.roomPrice : room1.roomPrice > room2.roomPrice
            }
            
            return HotelModel(
                id: hotel.id,
                hotelNameType: hotel.hotelNameType,
                latitude: hotel.latitude,
                longitude: hotel.longitude,
                contactNumber: hotel.contactNumber,
                address: hotel.address,
                roomObj: sortedRooms
            )
        }
    }
    
    // MARK: - Sort Hotels by Rating
    func sortHotelsByRating(ascending: Bool = false) -> [HotelModel] {
        return hotels.map { hotel in
            let sortedRooms = hotel.roomObj.sorted { room1, room2 in
                ascending ? room1.roomRating < room2.roomRating : room1.roomRating > room2.roomRating
            }
            
            return HotelModel(
                id: hotel.id,
                hotelNameType: hotel.hotelNameType,
                latitude: hotel.latitude,
                longitude: hotel.longitude,
                contactNumber: hotel.contactNumber,
                address: hotel.address,
                roomObj: sortedRooms
            )
        }
    }
    
    // MARK: - SwiftData Persistence
    func saveHotelsToSwiftData(context: ModelContext) {
        // Upsert hotels into SwiftData cache (HotelSwiftDataModel)
        do {
            // Fetch existing cached hotels to detect updates
            let descriptor = FetchDescriptor<HotelSwiftDataModel>()
            let existing = try context.fetch(descriptor)
            var existingById: [String: HotelSwiftDataModel] = [:]
            for h in existing { existingById[h.id] = h }

            // Insert or update
            for hotel in hotels {
                if let cached = existingById[hotel.id] {
                    // Update existing
                    if cached.hotelNameType != hotel.hotelNameType {
                        cached.hotelNameType = hotel.hotelNameType
                    }
                } else {
                    // Insert new
                    let newHotel = HotelSwiftDataModel(id: hotel.id, hotelNameType: hotel.hotelNameType)
                    context.insert(newHotel)
                }
            }

            // Optionally, remove entries not present anymore
            let currentIds = Set(hotels.map { $0.id })
            for (id, model) in existingById where !currentIds.contains(id) {
                context.delete(model)
            }

            try context.save()
        } catch {
            print("SwiftData save error: \(error)")
        }
    }

    func loadHotelsFromSwiftData(context: ModelContext) {
        // Load cached hotels for offline display
        do {
            let descriptor = FetchDescriptor<HotelSwiftDataModel>()
            let cached = try context.fetch(descriptor)
            // Map cached minimal model back to HotelModel with empty rooms (since we don't have Room SwiftData yet)
            let mapped: [HotelModel] = cached.map { HotelModel(id: $0.id, hotelNameType: $0.hotelNameType, latitude: "0.0", longitude: "0.0", contactNumber: "", address: "", roomObj: []) }
            self.hotels = mapped
            self.isLoading = false
            self.errorMessage = ""
        } catch {
            self.errorMessage = "Failed to load cached hotels: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    // MARK: - Cleanup
    deinit {
        listener?.remove()
    }
}
