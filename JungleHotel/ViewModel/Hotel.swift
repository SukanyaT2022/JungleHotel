//
//  Hotel.swift
//  JungleHotel
//
//  Created by TS2 on 8/29/25.
//

import Foundation

// MARK: - Hotel Model
struct Hotel: Identifiable, Codable {
    var id: String = UUID().uuidString
    let hotelNameType: String
    let roomObj: [Room]
    
    enum CodingKeys: String, CodingKey {
        case hotelNameType
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
extension Hotel {
    static let sampleHotel = Hotel(
        hotelNameType: "Top Tree Jungle Hotel",
        roomObj: [
            Room(
                roomAvailbility: "Available",
                roomDetail: "Mountain view",
                roomImage: [
                    "https://www.pexels.com/photo/majestic-mountain-peak-at-sunrise-with-clouds-32878857/",
                    "https://images.pexels.com/photos/3243789/pexels-photo-3243789.jpeg"
                ],
                roomName: "Forest room",
                roomPrice: 200,
                roomRating: 4.2
            )
        ]
    )
}
