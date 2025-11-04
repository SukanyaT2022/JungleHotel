//
//  CheckinCompView.swift
//  JungleHotel
//
//  Created by TS2 on 11/3/25.
//

import SwiftUI

struct CheckinCompView: View {
    var checkInDate: String
    var checkOutDate: String
    var nights: Int 
    
    var body: some View {
        HStack(spacing: 16) {
            // Check-in Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Check-in")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(checkInDate)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
   
            }
            
            // Arrow
            Image(systemName: "arrow.right")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .padding(.top, 20)
            
            // Check-out Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Check-out")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(checkOutDate)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
                
            }
            
            Spacer()
            
            // Nights Section
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(nights)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                
                Text("nights")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.top, 8)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
//        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    CheckinCompView(checkInDate: "", checkOutDate: "", nights: 1)
        .padding()
        .background(Color(.systemGray6))
}
