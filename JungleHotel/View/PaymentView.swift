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
    @State private var radioBtnSelected: Bool = false
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 16) {
                Text("Payment Details")
                    .font(.title)
                    .fontWeight(.bold)

                smallBoxComp(title: "Jungle Hotel", text: "Date check in and out", bgColor: Color.white)

                smallBoxComp(title: "", text: "We price match on all hotels", bgColor: Color(hex: "#BFF4BE"))

                BigBoxComp(
                    topTitle: "Room price",
                    topValue: "10,000",
                    bottomText: "Service fee:",
                    bottomValue:" You will be charged on 16 November 2025\n\nIncluded in total price: City tax 1%, Tax 7%, Service charge 10%\n\nYour currency selections affect the prices charged or displayed to you under these terms",
                    bgColor: Color(hex: "#F5F5F5"),
                    paymentCondition: ""
                )
                smallBoxComp(title: "", text: "We have only 4 rooms left", bgColor: Color(hex: "#BFF4BE"))
                
          
                //paynow or pay later
                BigBoxComp(
                    topTitle: "Room price",
                    topValue: "10,000",
                    bottomText: "Service fee:",
                    bottomValue:" You will be charged on 16 November 2025\n\nIncluded in total under these terms",
                    bgColor: Color(hex: "#F5F5F5"),
                    paymentCondition: "Pay Now"
                )
              
                
            }// end vstack
            .padding()
        }
        
    }
}

#Preview {
    PaymentView(checkinDatePayment: Date(), checkoutDatePayment: Date())
}

