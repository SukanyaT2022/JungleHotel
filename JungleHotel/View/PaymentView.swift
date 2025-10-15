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
        Text("Payment Details")
        smallBoxComp(title: "Jungle Hotel", text:"Date check in and out")
    
    }
}

#Preview {
    PaymentView(checkinDatePayment: Date(), checkoutDatePayment: Date())
}
