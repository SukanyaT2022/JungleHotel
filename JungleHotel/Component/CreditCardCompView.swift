//
//  CreditCardCompView.swift
//  JungleHotel
//
//  Created by TS2 on 10/22/25.
//

import SwiftUI

struct CreditCardCompView: View {
    var body: some View {
        HStack{
            Image("masterCard")
            Image("visaCardInput")
            Image("appleCard")
            Image("paypalCard")
        }
    }
}

#Preview {
    CreditCardCompView()
}
