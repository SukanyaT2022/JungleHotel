//
//  ContentView.swift
//  JungleHotel
//
//  Created by TS2 on 8/26/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {

            MainScreenView()
//            PaymentView(hotelModelPayment: HotelModel(hotelNameType: "", latitude: "", longitude: "", contactNumber: "", address: "", roomObj: []), roomPayment: Room(roomAvailbility: "", roomDetail: "", roomImage: [], roomName: "", roomPrice: 0, roomRating: 0.0), checkinDatePayment: Date(), checkoutDatePayment: Date())
//           
        }
       
//        padding to the mainscreen
            .padding(.horizontal, 20)
    }
}

#Preview {
    ContentView()
}
