//
//  BigBoxComp.swift
//  JungleHotel
//
//  Created by TS2 on 10/16/25.
//

import SwiftUI

struct BigBoxComp: View {
    let topTitle: String
    let topValue: String
    let bottomText: String
    let bottomValue: String
    let bgColor: Color
    let paymentCondition: String
    let paymentConditionBelow: String
    @State private var radioBtnSelected: Bool = false
    @State private var radioBtnSelectedBelow: Bool = false
    //we set paynow as default
    @State private var paymentConditionSelected: PaymentCondition = .payNow
    enum PaymentCondition: String, CaseIterable, Identifiable {
        case payNow = "Pay Now"
        case payLater = "Pay Later"
        //below make id as same value as id such paynow or paylater not id1, 2, 3
        var id: String { self.rawValue }
        //below generate unique id
//        var id : String {UUID().uuidString}
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0, ) {
            Text(topTitle)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.leading, 24)
       
                
            // Top Section
            HStack {
             
                if !paymentCondition.isEmpty {
                    RadioButtonView(
                        title: paymentCondition,
                        isSelected: paymentConditionSelected == .payNow,
                        discountText: "Pay now 5% discount") {
                        radioBtnSelected.toggle()
                    paymentConditionSelected = .payNow
                    }//end close radioBttinView
                }
               
                Spacer()
                //pay later pay now text
             VStack(alignment: .leading, spacing: 0) {
                 Text("$" + topValue)
                     .font(.headline)
                     .fontWeight(.semibold)
                     .foregroundColor(.primary)
                }
                
            }
            .padding(16)
            .background(Color.white)
            
//            Divider()
//                .frame(height: 4)
//                .background(Color.red)
//                .padding(.vertical, 8)
            //divider() is line between 2 box
            
            // Bottom Section pay later
            HStack(alignment: .top, spacing: 12) {
               VStack(alignment: .leading, spacing: 0) {
                   //radio button
                   if !paymentConditionBelow.isEmpty {
                       RadioButtonView(title: paymentConditionBelow, isSelected: paymentConditionSelected == .payLater, discountText:"") {
                           radioBtnSelectedBelow.toggle()
                       paymentConditionSelected = .payLater
                       }
                       .padding(.bottom, 8)
                       
                   }//closing if
                    Text(bottomText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .padding(.top,5)
                       
               }
              
               VStack{
                   //pay later
                   Text("$" + bottomValue)
                       .font(.headline)
                       .fontWeight(.semibold)
                       .foregroundColor(.primary)
                       .lineLimit(nil)
                       .fixedSize(horizontal: false, vertical: true)
               }// target on price number pay later only
            
               
              
            }//close hstack
            //target gray box paylater
            .padding(16)
            .background(bgColor)
            .frame(height: 80, alignment: .leading)
            .padding(.top, 10)
            .cornerRadius(20)
            //end h stcak prop
         
        }//vstack closing
        .padding(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.3), lineWidth: 1.5)
        )
        .cornerRadius(20)
    }
}

#Preview {
    VStack(spacing: 16) {
        BigBoxComp(
            topTitle: "Room price (1 room x 7 nights)",
            topValue: "฿ 10,818.30",
            bottomText: "You will be charged on 16  these terms",
            bottomValue: "฿ 10,818.30",
            bgColor: Color(.systemGray6),
            paymentCondition: "Pay Now", paymentConditionBelow: "Pay Later"
        )
    }
    .padding()
}

