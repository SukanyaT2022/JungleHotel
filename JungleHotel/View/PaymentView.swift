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
    @State private var isPromotionsChecked: Bool = true
    
    @State  var numNight: Int = 1
    @State  var pricePerNight: Int64 = 0
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20) {
                Text("Payment Details")
                    .font(.title)
                    .fontWeight(.bold)

                smallBoxComp(title: "Jungle Hotel", text: "Date check in and out", bgColor: Color.white)

                smallBoxComp(title: "", text: "We price match on all hotels", bgColor: Color(hex: "#BFF4BE"))

                BigBoxComp(
                    topTitle: "Room price",
                    topValue: "\((pricePerNight * Int64(numNight)).formatted())",
                    
                    bottomText: "",
                    bottomValue:"20000",
                    bgColor: Color(hex: "#F5F5F5"),
                    paymentCondition: "Pay Now", paymentConditionBelow: "Pay Later"
                    
                )
                smallBoxComp(title: "", text: "Service fee: You will be charged on 16 November 2025\n\nIncluded in total price: City tax 1%, Tax 7%, Service charge 10%\n\nYour currency selections affect the prices charged or displayed to you under these terms", bgColor: Color(hex: "#ffffff"))
                
            

                smallBoxComp(title: "", text: "We have only 4 rooms left", bgColor: Color(hex: "#BFF4BE"))
                
          
            
//                BigBoxComp(
//                    topTitle: "Room price",
//                    topValue: "10,000",
//                    bottomText: "Service fee:",
//                    bottomValue:" You will be charged on 16 November 2025\n\nIncluded in total under these terms",
//                    bgColor: Color(hex: "#F5F5F5"), paymentCondition: "Pay Now",
//                    paymentConditionBelow: "Pay Later"
//                )
                
                CheckBoxView(
                    text: "I agree receive update and promotions about Jungle Hotel.",
                    isChecked: $isPromotionsChecked,
                   
                ) {
                    
                }
//    payment method credit card
                
                PaymentMethodComp()
                
    //submit button
                ButtonCompView(textBtn: "Book Now",action: {
                 
                } )
            
            }// end vstack
            .padding(10)
        }
        .scrollIndicators(.hidden)
        // hide scroll bar from scrool view
        
    }
}

#Preview {
    PaymentView(
        checkinDatePayment: Date(),
        checkoutDatePayment: Date(),
        numNight: 2,
        pricePerNight: 12000
    )
}

