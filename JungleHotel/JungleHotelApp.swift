//
//  JungleHotelApp.swift
//  JungleHotel
//
//  Created by TS2 on 8/26/25.
//

import SwiftUI
import GoogleSignIn
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
    
    // Configure Firebase -- important mke app app connect
    FirebaseApp.configure()
    
    // Configure Google Sign-In with client ID from Info.plist
    if let clientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String {
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        print("Google Sign-In configured with client ID")
    } else {
        print("Warning: GIDClientID not found in Info.plist")
    }
    
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
  }//close function
    //sdk google copy and put below
    
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }//end application function
    
}

@main
struct JungleHotelApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
//        SuccessBookView(bookingData: [:])
//        MainScreenView()
        ContentView()
    }
//      step 8 line below for swiftdata
    .modelContainer(for: HotelSwiftDataModel.self)
  }
}
//step 9 go to main screenview
