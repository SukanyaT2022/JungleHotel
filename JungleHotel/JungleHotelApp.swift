//
//  JungleHotelApp.swift
//  JungleHotel
//
//  Created by TS2 on 8/26/25.
//

import SwiftUI

//@main
//struct JungleHotelApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

import SwiftUI
import FirebaseCore
import FirebaseFirestore
//step 7 import swiftdata
import SwiftData
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    // Configure Firebase
    FirebaseApp.configure()
    
    // Configure Firestore settings for better simulator performance
    let db = Firestore.firestore()
    let settings = FirestoreSettings()
    
    // Enable offline persistence
    settings.isPersistenceEnabled = true
    
    // Set cache size (100 MB)
    settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
    
    // Apply settings
    db.settings = settings
    
    // Disable App Check for simulator to avoid warnings
    #if targetEnvironment(simulator)
    print("Running on simulator - App Check warnings are expected")
    #endif

    return true
  }
}

@main
struct JungleHotelApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
      ContentView()
    }
//      step 8 line below for swiftdata
    .modelContainer(for: HotelSwiftDataModel.self)
  }
}
//step 9 go to main screenview
