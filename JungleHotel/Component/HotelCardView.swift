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
            // Room Images Carousel
            ImageCarouselView(images: room.roomImage)
                .frame(height: 200)
             
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 12,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 12
                    )
                )
             
            
            // Room Details
            VStack(alignment: .leading, spacing: 8) {
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
                    Text(room.roomAvailbility)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(room.roomAvailbility.lowercased() == "available" ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .foregroundColor(room.roomAvailbility.lowercased() == "available" ? .green : .red)
                        .cornerRadius(5)
            
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
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(4)
    }
}

// MARK: - Image Carousel View
struct ImageCarouselView: View {
    let images: [String]
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            if images.isEmpty {
                // Fallback image when no images available
                Image("waterfall")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else {
                // Image carousel
                TabView(selection: $currentIndex) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, imageURL in
                        AsyncImage(url: URL(string: imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            // Show fallback image while loading
                            Image("waterfall")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .clipped()
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Custom page indicators
                if images.count > 1 {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            
                            // Page indicators
                            HStack(spacing: 8) {
                                ForEach(0..<images.count, id: \.self) { index in
                                    Circle()
                                        .fill(index == currentIndex ? Color.white : Color.white.opacity(0.5))
                                        .frame(width: 8, height: 8)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(20)
                            .padding(.trailing, 16)
                            .padding(.bottom, 16)
                        }
                    }
                }
                
                // Image counter overlay
                if images.count > 1 {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Text("\(currentIndex + 1)/\(images.count)")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.black.opacity(0.6))
                                .cornerRadius(16)
                                .padding(.top, 16)
                                .padding(.trailing, 16)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    HotelCardView(
        room: HotelModel.sampleHotel.roomObj[0],
        hotelName: HotelModel.sampleHotel.hotelNameType
    )
}
