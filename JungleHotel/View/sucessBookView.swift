//
//  successBookView.swift
//  JungleHotel
//
//  Created by TS2 on 12/12/25.
//

import SwiftUI

struct SuccessBookView: View {
    // We bring booking data from payment view line 131 to here.
    @Environment(\.dismiss) var dismiss
    var onDismissToHome: () -> Void
    var bookingData: [String: Any]

    var body: some View {
        ZStack {
            Image("mountainview")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                Text("Successfully Booked!")
                    .font(.title).bold()
                    .foregroundColor(.white)
                
                let checkin = bookingData["checkinDate"] as? String ?? "—"
                let checkout = bookingData["checkoutDate"] as? String ?? "—"
                let pricePerNight = bookingData["pricePerNight"] as? Int64
                let totalPrice = bookingData["totalPrice"] as? Int64
                
                Text("Check-in Date: \(checkin)")
                    .foregroundColor(.white)
                Text("Check-out Date: \(checkout)")
                    .foregroundColor(.white)
                if let pricePerNight {
                    Text("Price per night: $\(pricePerNight)")
                        .foregroundColor(.white)
                }
                if let totalPrice {
                    Text("Total price: $\(totalPrice)")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                
                Button {
                    dismiss()
                    // Delay to allow dismiss animation to complete
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onDismissToHome()
                    }
                } label: {
                    Text("Back to HomeScreen")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 40)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
            .padding()
        } // close ZStack
    } // close body
} // close struct

#Preview {
    SuccessBookView(
        onDismissToHome: { print("Dismiss to home") },
        bookingData: [
            "checkinDate": "2025-12-24",
            "checkoutDate": "2025-12-28",
            "pricePerNight": Int64(199),
            "totalPrice": Int64(796)
        ]
    )
}
