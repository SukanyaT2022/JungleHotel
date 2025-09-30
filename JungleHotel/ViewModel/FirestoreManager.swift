//
//  FirestoreManager.swift
//  JungleHotel
//
//  Created by TS2 on 8/29/25.
//

import Foundation
import FirebaseFirestore
import Combine

// MARK: - Firestore Manager
class FirestoreManager: ObservableObject {
    private let db = Firestore.firestore()
    
    init() {
        // Configure Firestore for better performance
        configureFirestore()
    }
    
    private func configureFirestore() {
        // Enable network logging in debug mode
        #if DEBUG
        print("Firebase Firestore initialized")
        #endif
    }
    
    // MARK: - Fetch Hotels
    func fetchHotels() async throws -> [HotelModel] {
        do {
            print("Attempting to fetch hotels from Firestore...")
            let snapshot = try await db.collection("hotelData").getDocuments()
            print("Successfully fetched \(snapshot.documents.count) hotel documents")
            
            if snapshot.documents.isEmpty {
                print("Warning: No hotel documents found in 'hotelData' collection")
                return []
            }
        
            var hotels: [HotelModel] = []
            
            for document in snapshot.documents {
                let data = document.data()
                print("Processing document: \(document.documentID)")
                
                // Parse hotel data with better error handling
                guard let hotelNameType = data["hotelNameType"] as? String else {
                    print("Error: Missing or invalid 'hotelNameType' in document: \(document.documentID)")
                    continue
                }
                
                // Parse new fields with default values
                let latitude = data["latitude"] as? String ?? "0.0"
                let longitude = data["longitude"] as? String ?? "0.0"
                let contactNumber = data["contactNumber"] as? String ?? ""
                let address = data["address"] as? String ?? ""
                
                guard let roomObjData = data["roomObj"] as? [[String: Any]] else {
                    print("Error: Missing or invalid 'roomObj' in document: \(document.documentID)")
                    continue
                }
                
                // Parse rooms
                var rooms: [Room] = []
                for (index, roomData) in roomObjData.enumerated() {
                    if let room = parseRoom(from: roomData) {
                        rooms.append(room)
                        print("Successfully parsed room \(index + 1) for hotel: \(hotelNameType)")
                    } else {
                        print("Failed to parse room \(index + 1) for hotel: \(hotelNameType)")
                    }
                }
                
                let hotel = HotelModel(
                    id: document.documentID,
                    hotelNameType: hotelNameType,
                    latitude: latitude,
                    longitude: longitude,
                    contactNumber: contactNumber,
                    address: address,
                    roomObj: rooms
                )
                
                hotels.append(hotel)
                print("Successfully added hotel: \(hotelNameType) with \(rooms.count) rooms")
            }
            
            print("Total hotels parsed: \(hotels.count)")
            return hotels
            
        } catch {
            print("Firebase Error: \(error.localizedDescription)")
            throw error
        }
    }
    
        // MARK: - Parse Room Data
    private func parseRoom(from data: [String: Any]) -> Room? {
        // Parse with default values and detailed logging
        let roomAvailbility = data["roomAvailbility"] as? String ?? "Available"
        let roomDetail = data["roomDetail"] as? String ?? "No detail available"
        let roomImageArray = data["roomImage"] as? [String] ?? []
        let roomName = data["roomName"] as? String ?? "Unnamed Room"
        
        // Handle both Int and Int64 for roomPrice
        let roomPrice: Int64
        if let price = data["roomPrice"] as? Int64 {
            roomPrice = price
        } else if let price = data["roomPrice"] as? Int {
            roomPrice = Int64(price)
        } else {
            roomPrice = 0
            print("Warning: roomPrice not found or invalid, using default value 0")
        }
        
        let roomRating = data["roomRating"] as? Double ?? 0.0
        
        // Log parsed data for debugging
        print("Parsed room: \(roomName), Price: \(roomPrice), Rating: \(roomRating), Images: \(roomImageArray.count)")
        
        return Room(
            roomAvailbility: roomAvailbility,
            roomDetail: roomDetail,
            roomImage: roomImageArray,
            roomName: roomName,
            roomPrice: roomPrice,
            roomRating: roomRating
        )
    }
    
    // MARK: - Fetch Hotels with Listener (Real-time updates)
    func fetchHotelsWithListener(completion: @escaping ([HotelModel]) -> Void) -> ListenerRegistration {
        print("Setting up real-time listener for hotel data...")
        
        return db.collection("hotelData").addSnapshotListener { snapshot, error in
            if let error = error {
                print("❌ Firestore Listener Error: \(error.localizedDescription)")
                print("Error details: \(error)")
                completion([])
                return
            }
            
            guard let snapshot = snapshot else {
                print("❌ Snapshot is nil")
                completion([])
                return
            }
            
            print("📊 Listener snapshot metadata:")
            print("  - Has pending writes: \(snapshot.metadata.hasPendingWrites)")
            print("  - Is from cache: \(snapshot.metadata.isFromCache)")
            print("  - Document count: \(snapshot.documents.count)")
            
            if snapshot.documents.isEmpty {
                print("⚠️ No documents found in snapshot - this might be normal on first load")
                completion([])
                return
            }
            
            print("✅ Listener received \(snapshot.documents.count) documents")
            var hotels: [HotelModel] = []
            
            for document in snapshot.documents {
                let data = document.data()
                print("🏨 Listener processing document: \(document.documentID)")
                
                guard let hotelNameType = data["hotelNameType"] as? String,
                      let roomObjData = data["roomObj"] as? [[String: Any]] else {
                    print("❌ Listener: Invalid data structure in document: \(document.documentID)")
                    continue
                }
                
                // Parse new fields with default values for listener
                let latitude = data["latitude"] as? String ?? "0.0"
                let longitude = data["longitude"] as? String ?? "0.0"
                let contactNumber = data["contactNumber"] as? String ?? ""
                let address = data["address"] as? String ?? ""
                
                var rooms: [Room] = []
                for roomData in roomObjData {
                    if let room = self.parseRoom(from: roomData) {
                        rooms.append(room)
                    }
                }
                
                let hotel = HotelModel(
                    id: document.documentID,
                    hotelNameType: hotelNameType,
                    latitude: latitude,
                    longitude: longitude,
                    contactNumber: contactNumber,
                    address: address,
                    roomObj: rooms
                )
                
                hotels.append(hotel)
                print("✅ Successfully processed hotel: \(hotelNameType) with \(rooms.count) rooms")
            }
            
            print("🎉 Listener completed: \(hotels.count) hotels processed and ready to display")
            completion(hotels)
        }
    }
}
