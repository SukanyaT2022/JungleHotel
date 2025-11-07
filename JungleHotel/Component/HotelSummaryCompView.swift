//
//  HotelSummaryCompView.swift
//  JungleHotel
//
//  Created by TS2 on 11/4/25.
//

import SwiftUI

struct HotelSummaryCompView: View {
    var hotelImage: String
    var hotelName: String
    var rating: Int // 1-5 stars
    var reviewScore: Double
    var reviewCount: Int
    var address: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: URL(string: hotelImage)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                case .failure:
                    ZStack {
                        Color.gray.opacity(0.15)
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                    .frame(width: 140, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                case .empty:
                    ZStack {
                        Color.gray.opacity(0.1)
                        ProgressView()
                    }
                    .frame(width: 140, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            // Hotel Image
//            Image(hotelImage)
//                .resizable()
//                .scaledToFill()
//                .frame(width: 140, height: 140)
//                .clipShape(RoundedRectangle(cornerRadius: 12))
//            
            // Hotel Details
            VStack(alignment: .leading, spacing: 8) {
                
                // Hotel Name
                Text(hotelName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                // Star Rating
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < rating ? "star.fill" : "star")
                            .font(.system(size: 14))
                            .foregroundColor(index < rating ? Color.orange : Color.gray.opacity(0.3))
                    }
                }
                
                // Review Score and Count
                HStack(spacing: 6) {
                    Text(String(format: "%.1f", reviewScore))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.blue)
                    Text("Excellent")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.blue)
                }
                Text("\(reviewCount) reviews")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                       
                      
                
                // Address
                Text(address)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                // What's nearby link
                Button(action: {
                    // Action for what's nearby
                }) {
                    Text("What's nearby?")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.blue)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
    }
}

#Preview {
    HotelSummaryCompView(
        hotelImage: "beach",
        hotelName: "Hotel Wyndham Paris Pleyel Resort",
        rating: 4,
        reviewScore: 8.3,
        reviewCount: 2763,
        address: "149 - 153 Boulevard Anatole France, Saint Denis,..."
    )
    .padding()
    .background(Color(.systemGray6))
}




