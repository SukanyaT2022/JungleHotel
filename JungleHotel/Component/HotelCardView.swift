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
        ZStack(alignment: .top) {
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
            
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12, weight: .semibold))
                    Text(String(format: "%.1f", room.roomRating))
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.9))
                .clipShape(Capsule())
                
                Spacer()
                
                Image(systemName: "heart")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.white.opacity(0.25))
                    .clipShape(Circle())
            }
            .padding(12)
            
            VStack {
                Spacer()
                
                LinearGradient(
                    colors: [Color.black.opacity(0.0), Color.black.opacity(0.55)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 90)
                .overlay(
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(hotelName)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                                Text(room.roomDetail)
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Text("$\(room.roomPrice)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Text("/night")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 12),
                    alignment: .bottom
                )
            }
        }
        .frame(width: 280, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.35), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 8)
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
