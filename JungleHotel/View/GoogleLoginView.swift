//
//  LoginView.swift
//  JungleHotel
//
//  Created by TS2 on 11/6/25.
//

import SwiftUI
import GoogleSignIn

struct GoogleLoginView
: View {
    @State private var errorMessage: String?
    @State private var showSuccessAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    @Environment(\.dismiss) var dismiss
    
    private func handleSignInButton() {
        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else {
            print("Could not find root view controller")
            errorMessage = "Could not find root view controller"
            showErrorAlert = true
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            if let error = error {
                print("Google Sign-In error: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
                showErrorAlert = true
                return
            }
            
            guard let result = signInResult else {
                print("No result returned from sign-in")
                errorMessage = "Sign-in failed: No result returned"
                showErrorAlert = true
                return
            }
            
            // Successfully signed in
            let user = result.user
            print("Successfully signed in!")
            print("User ID: \(user.userID ?? "N/A")")
            print("Email: \(user.profile?.email ?? "N/A")")
            print("Full Name: \(user.profile?.name ?? "N/A")")
            
            // Store user info for alert
            userName = user.profile?.name ?? "User"
            userEmail = user.profile?.email ?? ""
            
            // Show success alert
            showSuccessAlert = true
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Sign in with Google")
                    .font(.title)
                    .padding()
                
                // Custom Google Sign-In Button
                Button(action: handleSignInButton) {
                    HStack {
                        Image(systemName: "g.circle.fill")
                            .font(.title2)
                        Text("Sign in with Google")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
            
            // Success Alert Overlay
            if showSuccessAlert {
                SuccessAlertView(
                    title: "Login Successful!",
                    message: "Welcome back, \(userName)!\nYou have successfully signed in.",
                    isPresented: $showSuccessAlert,
                    onDismiss: {
                        // Dismiss the login view after alert
                        dismiss()
                    }
                )
            }
            
            // Error Alert Overlay
            if showErrorAlert {
                ErrorAlertView(
                    title: "Login Failed",
                    message: errorMessage ?? "An unknown error occurred. Please try again.",
                    isPresented: $showErrorAlert
                )
            }
        }
    }
}

#Preview {
    GoogleLoginView()
}
