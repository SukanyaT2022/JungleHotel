//
//  PaymentView.swift
//  JungleHotel
//
//  Created by TS2 on 8/26/25.
//

import SwiftUI

struct PaymentView: View {
    var checkinDatePayment: Date
    var checkoutDatePayment: Date
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Payment Details")
                .font(.title)
                .fontWeight(.bold)

            smallBoxComp(title: "Jungle Hotel", text: "Date check in and out", bgColor: Color.white)

            smallBoxComp(title: "", text: "We price match on all hotels", bgColor: Color.green)

            BigBoxComp(
                topTitle: "Room price",
                topValue: "10,000",
                bottomText: "Service fee:",
                bottomValue:" 10,000",
                bgColor: .gray
            )
        }
        .padding()
    }
}

#Preview {
    PaymentView(checkinDatePayment: Date(), checkoutDatePayment: Date())
}
