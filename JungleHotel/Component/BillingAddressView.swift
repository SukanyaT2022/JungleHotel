//
//  BillingAddressView.swift
//  JungleHotel
//
//  Created by TS2 on 11/25/25.
//

import SwiftUI

struct BillingAddressView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Billing Address")
                .font(.title3)
                .bold()
            InputCompView(textLabel: "Address")
            InputCompView(textLabel: "City")
            InputCompView(textLabel: "State/Provience")
            InputCompView(textLabel: "Zip/Postal Code")
 
        }
        
    }
}

#Preview {
    BillingAddressView()
}
