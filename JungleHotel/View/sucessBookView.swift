//
//  sucessBookView.swift
//  JungleHotel
//
//  Created by TS2 on 12/12/25.
//

import SwiftUI

struct SuccessBookView: View {
//    we bring booking data from payment view line 131 to here.
    var bookingData: [String: Any]
    var body: some View {
        Text("Sucessfully Booked!")
        Text("Checkin Date:\(bookingData["checkinDate"] as! String)")
        Text("CheckoutDate:\(bookingData["checkoutDate"] as! String)")
        Text("Price pernight: \(bookingData["pricePerNight"] as!  Int64)")
        Text("Price total:\(bookingData["totalPrice"] as!  Int64)")
    }
}

#Preview {
//    SuccessBookView()
}
