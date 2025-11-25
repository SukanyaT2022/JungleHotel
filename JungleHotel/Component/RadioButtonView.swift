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
                        .frame(width: 16, height: 16)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                    }
                }
//                end raio circle
                
                // Title Text
                VStack(alignment: .leading, spacing: 5){
                    if !title.isEmpty {
                        Text(title)
                            .font(Font(UIFont(name: "Verdana", size: 16)!))
                            .foregroundColor(.primary)
                    }
                    
                       
                    if !discountText.isEmpty {
                        Text(discountText)
                            .font(Font(UIFont(name: "Verdana", size: 12)!))
                    }
                  
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
