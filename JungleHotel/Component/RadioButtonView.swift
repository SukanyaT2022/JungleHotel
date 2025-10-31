//
//  RadioButtonView.swift
//  JungleHotel
//
//  Created by TS2 on 10/21/25.
//

import SwiftUI

struct RadioButtonView: View {
    let title: String
    let isSelected: Bool
    let discountText: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(alignment:.top,spacing: 12) {
                // Radio Circle
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 2)
                        .frame(width: 20, height: 20)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 14, height: 14)
                    }
                }
//                end raio circle
                
                // Title Text
                VStack(alignment: .leading, spacing: 6){
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primary)
                    Text(discountText)
                        .font(.caption)
                }
               
                
                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        RadioButtonView(
            title: "Pay on 16 November 2025",
            isSelected: true,
            discountText: "10% off",
            action: {}
        )
        
        RadioButtonView(
            title: "Pay now",
            isSelected: false,
            discountText: "",
            action: {}
        )
    }
    .padding()
}
