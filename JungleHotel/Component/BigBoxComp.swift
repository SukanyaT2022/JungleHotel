//
//  BigBoxComp.swift
//  JungleHotel
//
//  Created by TS2 on 10/16/25.
//

import SwiftUI

struct BigBoxComp: View {
    let topTitle: String
    let topValue: String
    let bottomText: String
    let bottomValue: String
    let bgColor: Color
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Section
            HStack {
                Text(topTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(topValue)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .padding(16)
            .background(Color.white)
            
            Divider()
            
            // Bottom Section
           HStack(alignment: .center, spacing: 12) {
                Text(bottomText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
               Spacer()
               Text(bottomValue)
                   .font(.subheadline)
                   .foregroundColor(.secondary)
                   .lineLimit(nil)
                   .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(bgColor)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(20)
    }
}

#Preview {
    VStack(spacing: 16) {
        BigBoxComp(
            topTitle: "Room price (1 room x 7 nights)",
            topValue: "฿ 10,818.30",
            bottomText: "You will be charged on 16 November 2025\n\nIncluded in total price: City tax 1%, Tax 7%, Service charge 10%\n\nYour currency selections affect the prices charged or displayed to you under these terms",
            bottomValue: "฿ 10,818.30",
            bgColor: Color(.systemGray6)
        )
    }
    .padding()
}

