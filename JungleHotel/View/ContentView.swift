//
//  ContentView.swift
//  JungleHotel
//
//  Created by TS2 on 8/26/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        bottom tab bar
        TabView {
            MainScreenView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
          BookingBottomView()
                .tabItem {
                    Label("Booking", systemImage: "suitcase")
                     
                }
            ProfileView()
                  .tabItem {
                      Label("Profile", systemImage: "person")
                       
                  }
         
            }//close tabview
//        change color icon below
        .tint(Color(.green))
        }
       
}

#Preview {
    ContentView()
}
