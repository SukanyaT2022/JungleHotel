//
//  PaymentCompView.swift
//  JungleHotel
//
//  Created by TS2 on 10/22/25.
//

import SwiftUI

struct PaymentCompView: View {
    var body: some View {
       VStack {
            Text("Payment Method")
               .font(Font.largeTitle)
           Text("Encrypted and secure")
           RadioButtonView(title: "Credit/debit card", isSelected: false) {
               
           }
           PaymentCompView()
           // input box
           Divider()
           RadioButtonView(title: "Digital payment", isSelected: false) {
               
           }
           
        }
    }
}

#Preview {
    PaymentCompView()
}
