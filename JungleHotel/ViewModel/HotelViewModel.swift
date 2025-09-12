//
//  HotelViewModel.swift
//  JungleHotel
//
//  Created by TS2 on 8/29/25.
//

import Foundation
import Combine
import FirebaseFirestore

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
        listener = firestoreManager.fetchHotelsWithListener { [weak self] hotels in
            DispatchQueue.main.async {
                self?.hotels = hotels
                self?.isLoading = false
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
                roomObj: sortedRooms
            )
        }
    }
    
    // MARK: - Cleanup
    deinit {
        listener?.remove()
    }
}
