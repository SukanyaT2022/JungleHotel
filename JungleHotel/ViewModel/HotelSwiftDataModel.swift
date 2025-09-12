//
//  Hotel.swift
//  JungleHotel
//
//  Created by TS2 on 8/29/25.
//

import Foundation
//step3 import swiftdata
import SwiftData


//step1  on swift data change from struct to class- remove word codbable
//step 2 ad @Model
@Model
class HotelSwiftDataModel: Identifiable {
    var id: String = UUID().uuidString
    let hotelNameType: String
   
//   step 4 add init on swiftdata
    init(id: String, hotelNameType: String) {
        self.id = id
        self.hotelNameType = hotelNameType
 
    }

}

//next aster step 4 go to JungleHotelApp which is entry point
