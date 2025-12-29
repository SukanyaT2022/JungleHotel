//
//  successBookView.swift
//  JungleHotel
//
//  Created by TS2 on 12/12/25.
//

import SwiftUI

struct SuccessBookView: View {
//    we bring booking data from payment view line 131 to here.
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

                let checkin = bookingData["checkinDate"] as? String ?? "—"
                let checkout = bookingData["checkoutDate"] as? String ?? "—"
                let pricePerNight = bookingData["pricePerNight"] as? Int64
                let totalPrice = bookingData["totalPrice"] as? Int64

                Text("Check-in Date: \(checkin)")
                Text("Check-out Date: \(checkout)")
                if let pricePerNight { Text("Price per night: \(pricePerNight)") }
                if let totalPrice { Text("Total price: \(totalPrice)") }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
//                    .fill(.ultraThinMaterial)
                    .fill(.windowBackground)
            )
            .padding()
        }
    }
}

#Preview {
    SuccessBookView(bookingData: [
        "checkinDate": "2025-12-24",
        "checkoutDate": "2025-12-28",
        "pricePerNight": Int64(199),
        "totalPrice": Int64(796)
    ])
}
