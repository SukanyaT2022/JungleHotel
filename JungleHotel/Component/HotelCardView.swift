//
//  HotelCardView.swift
//  JungleHotel
//
//  Created by TS2 on 8/26/25.
//

import SwiftUI

struct HotelCardView: View {
    let room: Room
    let hotelName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Room Image
            AsyncImage(url: URL(string: room.roomImage.first ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image("waterfall")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(height: 200)
            .clipped()
            
            // Room Details
            VStack(alignment: .leading, spacing: 8) {
                // Hotel Name
                Text(hotelName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Room Name
                Text(room.roomName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Room Detail
                Text(room.roomDetail)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Rating
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", room.roomRating))
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    // Availability
                    Text(room.roomAvailability)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(room.roomAvailability.lowercased() == "available" ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .foregroundColor(room.roomAvailability.lowercased() == "available" ? .green : .red)
                        .cornerRadius(4)
                }
                
                // Price
                HStack {
                    Text("$\(room.roomPrice)")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("per night")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.leading, 24)
            .padding(.vertical, 16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(4)
    }
}

#Preview {
    HotelCardView(
        room: Hotel.sampleHotel.roomObj[0],
        hotelName: Hotel.sampleHotel.hotelNameType
    )
}
