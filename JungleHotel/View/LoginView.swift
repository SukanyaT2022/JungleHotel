//
//  LoginView.swift
//  JungleHotel
//
//  Created by TS2 on 11/6/25.
//

import SwiftUI
import GoogleSignInSwift
struct LoginView: View {
    func handleSignInButton() {
      GIDSignIn.sharedInstance.signIn(
        withPresenting: rootViewController) { signInResult, error in
          guard let result = signInResult else {
            // Inspect error
            return
          }
          // If sign in succeeded, display the app's main content View.
        }
      )
    }
    //function for sign out
//    GIDSignIn.sharedInstance.signOut()
  
    var body: some View {
        GoogleSignInButton(action: handleSignInButton)
        
//        Button("sign out") {
//          
//        }
        
    }
    
}

#Preview {
    LoginView()
}
