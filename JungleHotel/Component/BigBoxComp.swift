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
    @State private var radioBtnSelected: Bool = false
    @State private var radioBtnSelectedBelow: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0, ) {
            Text(topTitle)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.leading, 24)
                
            // Top Section
            HStack {
             
                if !paymentCondition.isEmpty {
                    RadioButtonView(title: paymentCondition, isSelected: radioBtnSelected) {
                        radioBtnSelected.toggle()
                    
                    }//end close radioBttinView
                }
               
                Spacer()
                //pay later pay now text
                Text(topValue)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .padding(16)
            .background(Color.white)
            
//            Divider()
//                .frame(height: 4)
//                .background(Color.red)
//                .padding(.vertical, 8)
            //divider() is line between 2 box
            
            // Bottom Section
           HStack(alignment: .center, spacing: 12) {
               VStack(alignment: .leading, spacing: 0) {
                   //radio button
                   if !paymentCondition.isEmpty {
                       RadioButtonView(title: paymentCondition, isSelected: radioBtnSelectedBelow) {
                           radioBtnSelectedBelow.toggle()
                       
                       }
                       .padding(.bottom, 8)
                       
                   }//closing if
                    Text(bottomText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
               }
              
              
               Text(bottomValue)
                   .font(.subheadline)
                   .foregroundColor(.secondary)
                   .lineLimit(nil)
                   .fixedSize(horizontal: false, vertical: true)
            }//close hstack
            
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(bgColor)
            .cornerRadius(20)
            //end h stcak prop
         
        }//vstack closing
        .padding(10)
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
            paymentCondition: "Pay later available"
        )
    }
    .padding()
}

