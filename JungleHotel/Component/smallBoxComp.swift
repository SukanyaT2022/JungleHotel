//
//  smallBoxComp.swift
//  JungleHotel
//
//  Created by TS2 on 10/15/25.
//

import SwiftUI

struct smallBoxComp: View {
    let title: String
    let text: String
    let bgColor: Color 
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(bgColor)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
        )
        .cornerRadius(20)
    }
}

#Preview {
    
//    VStack(spacing: 16) {
//        smallBoxComp(
//            title: "Sample Title",
//            text: "This is a sample text description inside the box component."
//        )
//        
//
//    }
//    .padding()
}
