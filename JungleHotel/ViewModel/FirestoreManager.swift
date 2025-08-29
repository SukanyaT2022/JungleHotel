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
    
    // MARK: - Fetch Hotels
    func fetchHotels() async throws -> [Hotel] {
        let snapshot = try await db.collection("hotelData").getDocuments()
        
        var hotels: [Hotel] = []
        
        for document in snapshot.documents {
            let data = document.data()
            
            // Parse hotel data
            guard let hotelNameType = data["hotelNameType"] as? String,
                  let roomObjData = data["roomObj"] as? [[String: Any]] else {
                print("Error parsing hotel data for document: \(document.documentID)")
                continue
            }
            
            // Parse rooms
            var rooms: [Room] = []
            for roomData in roomObjData {
                if let room = parseRoom(from: roomData) {
                    rooms.append(room)
                }
            }
            
            let hotel = Hotel(
                id: document.documentID,
                hotelNameType: hotelNameType,
                roomObj: rooms
            )
            
            hotels.append(hotel)
        }
        
        return hotels
    }
    
    // MARK: - Parse Room Data
    private func parseRoom(from data: [String: Any]) -> Room? {
        guard let roomAvailability = data["roomAvailbility"] as? String,
              let roomDetail = data["roomDetail"] as? String,
              let roomImageArray = data["roomImage"] as? [String],
              let roomName = data["roomName"] as? String,
              let roomPrice = data["roomPrice"] as? Int64,
              let roomRating = data["roomRating"] as? Double else {
            print("Error parsing room data")
            return nil
        }
        
        return Room(
            roomAvailability: roomAvailability,
            roomDetail: roomDetail,
            roomImage: roomImageArray,
            roomName: roomName,
            roomPrice: roomPrice,
            roomRating: roomRating
        )
    }
    
    // MARK: - Fetch Hotels with Listener (Real-time updates)
    func fetchHotelsWithListener(completion: @escaping ([Hotel]) -> Void) -> ListenerRegistration {
        return db.collection("hotelData").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching hotels: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion([])
                return
            }
            
            var hotels: [Hotel] = []
            
            for document in documents {
                let data = document.data()
                
                guard let hotelNameType = data["hotelNameType"] as? String,
                      let roomObjData = data["roomObj"] as? [[String: Any]] else {
                    continue
                }
                
                var rooms: [Room] = []
                for roomData in roomObjData {
                    if let room = self.parseRoom(from: roomData) {
                        rooms.append(room)
                    }
                }
                
                let hotel = Hotel(
                    id: document.documentID,
                    hotelNameType: hotelNameType,
                    roomObj: rooms
                )
                
                hotels.append(hotel)
            }
            
            completion(hotels)
        }
    }
}
