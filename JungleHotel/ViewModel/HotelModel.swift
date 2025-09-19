//
//  Hotel.swift
//  JungleHotel
//
//  Created by TS2 on 8/29/25.
//

import Foundation

// MARK: - Hotel Model
struct HotelModel: Identifiable, Codable {
    var id: String = UUID().uuidString
    let hotelNameType: String
    let latitude: String
    let longitude: String
    let contactNumber: String
    let address: String
    let roomObj: [Room]
    
    enum CodingKeys: String, CodingKey {
        case hotelNameType
        case latitude
        case longitude
        case contactNumber
        case address
        case roomObj
    }
}

// MARK: - Room Model
struct Room: Identifiable, Codable {
    var id: String = UUID().uuidString
    let roomAvailbility: String
    let roomDetail: String
    let roomImage: [String]
    let roomName: String
    let roomPrice: Int64
    let roomRating: Double
    
    enum CodingKeys: String, CodingKey {
        case roomAvailbility
        case roomDetail
        case roomImage
        case roomName
        case roomPrice
        case roomRating
    }
}

// MARK: - Sample Data for Preview
extension HotelModel {
    static let sampleHotel = HotelModel(
        hotelNameType: "Top Tree Jungle Hotel",
        latitude: "19.9072",
        longitude: "99.8331",
        contactNumber: "+66-53-123-456",
        address: "88 Moo 3, Mae Rim District, Chiang Mai 50180, Northern Thailand",
        roomObj: [
            Room(
                roomAvailbility: "Available",
                roomDetail: "Mountain view",
                roomImage: [
                    "https://images.pexels.com/photos/338504/pexels-photo-338504.jpeg",
                    "https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg",
                    "https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg",
                    "https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg"
                ],
                roomName: "Forest room",
                roomPrice: 200,
                roomRating: 4.2
            )
        ]
    )
}
