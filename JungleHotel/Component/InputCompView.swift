//
//  SwiftUIView.swift
//  JungleHotel
//
//  Created by TS2 on 11/25/25.
//

import SwiftUI

struct InputCompView: View {
    @State var textLabel: String = "Label"
    @State private var textValue: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 2) {
                Text(textLabel)
                    .font(.system(size: 14))
                Text("*")
                    .foregroundStyle(.red)
            }
            TextField(textValue, text: $textValue)
                .textFieldStyle(.plain)
                .padding(.horizontal, 12)
                .frame(height: 45)
                .background(Color.gray.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .cornerRadius(10)
        }//close v stack
//        .padding()
    }
}

#Preview {
    InputCompView()
}
