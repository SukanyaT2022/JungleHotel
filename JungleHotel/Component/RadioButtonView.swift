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
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: 12) {
                // Radio Circle
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 14, height: 14)
                    }
                }
                
                // Title Text
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
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
            action: {}
        )
        
        RadioButtonView(
            title: "Pay now",
            isSelected: false,
            action: {}
        )
    }
    .padding()
}
