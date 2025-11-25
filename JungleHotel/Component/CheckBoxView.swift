//
//  CheckBoxView.swift
//  JungleHotel
//
//  Created by TS2 on 10/22/25.
//

import SwiftUI

struct CheckBoxView: View {
    let text: String
    @Binding var isChecked: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
            action()
        }) {
            HStack(alignment: .top, spacing: 12) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isChecked ? Color.blue : Color.gray, lineWidth: 2)
                        .frame(width: 16, height: 16)

                    if isChecked {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue)
                            .frame(width: 16, height: 16)

                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Text
                Text(text)
                    .font(ThemeFont.smallText)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
        )
        .cornerRadius(20)
    }
}

#Preview {
    VStack(spacing: 20) {
        CheckBoxView(
            text: "I agree to receive updates and promotions about Agoda and its affiliates or business partners via various channels, including WhatsApp. Opt out anytime. Read more in the Privacy Policy.",
            isChecked: .constant(true),
            action: {}
        )

        CheckBoxView(
            text: "Send me promotional emails",
            isChecked: .constant(false),
            action: {}
        )
        
    }
    .padding()
}

