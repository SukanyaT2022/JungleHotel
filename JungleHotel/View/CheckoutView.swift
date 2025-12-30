//
//  CheckoutView.swift
//  JungleHotel
///Users/ts2/Documents/swift2025/swiftui2025paw/JungleHotel/JungleHotel/View
//  Created by TS2 on 8/26/25.

import SwiftUI

struct  CheckoutView: View {
    var body: some View {
        Image(uiImage: UIImage(named: "beach") ?? UIImage(systemName: "beach.umbrella")!)
            .resizable()
            .frame(width: UIScreen.main.bounds.width, height: 300)
    }
}

#Preview {
   CheckoutView()
}
