//
//  SwiftUIView.swift
//  JungleHotel
//
//  Created by TS2 on 9/15/25.
//

import SwiftUI
import SwiftData

struct PracticeSwiftData: View {
    
    //    step 9 for swiftdata 2line below- we create context create key to get data
    @Environment(\.modelContext) var context
    //    alldata will save in qury variable
    @Query private var hotels: [HotelSwiftDataModel]
    
    
    var body: some View {
        //step 10 -- add hotel on swiftData- for swiftdata block code below- button
        Button("Add hotel") {
            let newHotel = HotelSwiftDataModel(id: UUID().uuidString, hotelNameType: "New Hotel")
            context.insert(newHotel)
            /* context.save --save in the container*/
            try? context.save()
        }
        ScrollView{
            //swipe to delete swip work with list only that why it differ than normal delete
            List{
                ForEach(hotels, id: \.id) { singleHotel in
                    Text(singleHotel.hotelNameType)
                    //add delete btn
                    Button("Swip to Delete") {
                        context.delete(singleHotel)
                        try? context.save()
                    }
                    //add update btn
                    Button("Update") {
                        singleHotel.hotelNameType = "Updated Hotel"
                        try? context.save()
                    }
                }//for each close
                .onDelete { indexSet in
                        for index in indexSet {
                            context.delete(hotels[index])
                        }
                        try? context.save()
                    }
            }
            .frame(width:300,height:500)
            //                        end step 10 swiftdata
            
//            List(hotels) { singleHotel in
//                Text(singleHotel.hotelNameType)
//                //add delete btn
//                Button("Delete") {
//                    context.delete(singleHotel)
//                    try? context.save()
//                }
//                //add update btn
//                Button("Update") {
//                    singleHotel.hotelNameType = "Updated Hotel"
//                    try? context.save()
//                }
//            }
//            .frame(width:300,height:500)
//            //                        end step 10 swiftdata
        }
    }
    
}
