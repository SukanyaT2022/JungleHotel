//
//  HotelCardView.swift
//  JungleHotel
//
//  Created by TS2 on 8/26/25.
//

import SwiftUI

struct HotelCardView: View {
    var body: some View {
        VStack(alignment:.leading){
            
            Image("waterfall")
                .resizable()
                .aspectRatio(contentMode:.fill)
                .frame( height: 200)
             
                .clipped()
            VStack(alignment:.leading, spacing:8){
                Text("Waterfall View")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("In front of waterfall.")
                Text("$100")
                Text("avg. night price")
            }//close text v stack
            .padding(.leading,24)
            .padding(.vertical,16)
        }//parent close
        .border(Color.gray, width: 1)
        .padding(4)
     
    }
}

#Preview {
    HotelCardView()
}
