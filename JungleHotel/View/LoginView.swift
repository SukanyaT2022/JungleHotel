//
//  LoginView.swift
//  JungleHotel
//
//  Created by TS2 on 11/6/25.
//

import SwiftUI

#if canImport(GoogleSignInSwift)
import GoogleSignInSwift
import GoogleSignIn
#endif

private extension View {
    // Helper to find a presenting UIViewController for sign-in
    func rootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first,
              let root = window.rootViewController else { return nil }
        var top = root
        while let presented = top.presentedViewController { top = presented }
        return top
    }
}

struct LoginView: View {
    private func handleSignInButton() {
        #if canImport(GoogleSignInSwift)
        guard let presenter = rootViewController() else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: presenter) { signInResult, error in
            if let error = error {
                // Inspect error
                print("Google Sign-In error: \(error)")
                return
            }
            guard let _ = signInResult else {
                // No result returned
                return
            }
            // If sign in succeeded, display the app's main content View.
            // TODO: Navigate to main content.
        }
        #else
        // GoogleSignInSwift not available; no-op
        #endif
    }

    var body: some View {
        #if canImport(GoogleSignInSwift)
        GoogleSignInButton(action: handleSignInButton)
        #else
        Button("Sign in with Google (module missing)") {
            handleSignInButton()
        }
        .disabled(true)
        .foregroundStyle(.secondary)
        #endif
    }
}

#Preview {
    LoginView()
}
