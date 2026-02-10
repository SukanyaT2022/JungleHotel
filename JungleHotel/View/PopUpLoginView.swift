//
//  PopUpLoginView.swift
//  JungleHotel
//
//  Created by TS2 on 11/7/25.
//

import SwiftUI
import FirebaseAuth

enum SocialIconType: String, CaseIterable {
    case google
//    case facebook
//    case apple
}
struct PopUpLoginView: View {
    @State private var googleSiginPopupVisible: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var showPassword: Bool = false
    @State private var isLoading: Bool = false
    @State private var authErrorMessage: String? = nil
    @Environment(\.dismiss) var dismiss
    @State private var isSignup : Bool = false
    @State private var showAlertNotCorrectPassword : Bool = false
    @State var loginType: SocialIconType = .google
    
    // Helper function to return destination view based on login type
    @ViewBuilder
    func destinationView() -> some View {
        switch loginType {
        case .google:
            GoogleLoginView()
//        case .facebook:
//            Text("Facebook Login View")
//                .font(.title)
//        case .apple:
//            Text("Apple Login View")
//                .font(.title)
     
        }
    }
    
    // Basic email format validation
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    // Perform Firebase email/password sign in
    private func signInWithEmailPassword() {
        authErrorMessage = nil
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.isEmpty else {
            authErrorMessage = "Please enter both email and password."
            return
        }
        guard isValidEmail(email) else {
            authErrorMessage = "Please enter a valid email address."
            return
        }

        isLoading = true
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: trimmedEmail, password: password) { result, error in
            isLoading = false
            if let error = error as NSError? {
                print(error.code)
                showAlertNotCorrectPassword = true
                // Map common Firebase Auth errors to friendly messages
//                switch AuthErrorCode.Code(rawValue: error.code) {
//                case .wrongPassword:
//                    authErrorMessage = "Incorrect password. Please try again."
//                case .invalidEmail:
//                    authErrorMessage = "The email address is badly formatted."
//                case .userNotFound:
//                    authErrorMessage = "No account found with this email."
//                case .networkError:
//                    authErrorMessage = "Network error. Please check your connection."
//                default:
//                    authErrorMessage = error.localizedDescription
//                }
                return
            }
            // Success — dismiss this view
            dismiss()
        }
    }
    
    // Perform Firebase email/password sign up
    private func signUpWithEmailPassword() {
        authErrorMessage = nil
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.isEmpty else {
            authErrorMessage = "Please enter both email and password."
            return
        }
        guard isValidEmail(email) else {
            authErrorMessage = "Please enter a valid email address."
            return
        }

        isLoading = true
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().createUser(withEmail: trimmedEmail, password: password) { result, error in
            isLoading = false
            if let error = error as NSError? {
//                switch AuthErrorCode.Code(rawValue: error.code) {
//                case .emailAlreadyInUse:
//                    authErrorMessage = "An account already exists with this email."
//                case .invalidEmail:
//                    authErrorMessage = "The email address is badly formatted."
//                case .weakPassword:
//                    authErrorMessage = "Password is too weak. Please use at least 6 characters."
//                case .networkError:
//                    authErrorMessage = "Network error. Please check your connection."
//                default:
//                    authErrorMessage = error.localizedDescription
//                }
                return
            }
            // Success — dismiss this view (or navigate onward)
            dismiss()
        }
    }
    
    var body: some View {
        NavigationStack {
            

        ZStack {
            // Background
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Back Button
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Colors.textPrimary)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial, in: Circle())
                            .overlay(
                                Circle().stroke(Color.white.opacity(0.6), lineWidth: 1)
                            )
                            .clipShape(Circle())
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                .padding(.top, 30)
                
                Spacer()
                    .frame(height: 20)
                
                // Card Container
                VStack(spacing: 24) {
                    // Logo
                    VStack(spacing: 16) {
                        Image("logoimage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    }
                    .padding(.top, 0)
                    
                    // Auth error message
                    if let authErrorMessage {
                        Text(authErrorMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    VStack(spacing: 20) {
                        
              
                    // Email Field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(Colors.textSecondary)
                            .frame(width: 20)
                        
                        TextField("Enter your email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .font(.system(size: 15))
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.white.opacity(0.6), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                    
                    // Password Field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(Colors.textSecondary)
                            .frame(width: 20)
                        
                        if showPassword {
                            TextField("Enter your password", text: $password)
                                .font(.system(size: 15))
                        } else {
                            SecureField("Enter your password", text: $password)
                                .font(.system(size: 15))
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye" : "eye.slash")
                                .foregroundColor(Colors.textSecondary)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.white.opacity(0.6), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                    
                    // Remember Me and Forgot Password
                    HStack {
                        Button(action: {
                            rememberMe.toggle()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                    .foregroundColor(rememberMe ? Colors.primary : Colors.textSecondary)
                                    .font(.system(size: 18))
                                
                                Text("Remember me")
                                    .font(.system(size: 14))
                                    .foregroundColor(Colors.textSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Forgot password action
                        }) {
                            Text("Forgot password")
                                .font(.system(size: 14))
                                .foregroundColor(Colors.textSecondary)
                        }
                    }
                    .padding(.horizontal,20)
                    
                    }
                    .padding(.horizontal, 28)
                    //close v stack wrap email password remember me
                    
                    
                    //wrap sign in and sign out button
                    VStack(spacing: 0) {
                        // Sign In Button
                        Button(action: {
                            if !isLoading {
                                signInWithEmailPassword()
                            }
                        }) {
                            HStack(spacing: 8) {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                }
                                Text(isLoading ? "Signing in..." : "Sign in")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 300, height: 20)
                            .padding()
                            .background(Colors.primary)
                            .opacity(isLoading ? 0.8 : 1.0)
                            .cornerRadius(26)
                        }
                        .disabled(isLoading)
                        .padding(.horizontal, 24)
                        
                        // Sign Up Button (create account)
                        NavigationLink("", destination: SignUpView(), isActive: $isSignup)
                        Button(action: {
                            if !isLoading {
                            isSignup = true
                            }
                        }) {
                            Text(isLoading ? "Creating account..." : "Sign up")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 300, height: 20)
                        .padding()
                        .background(Colors.primary)
                        .opacity(isLoading ? 0.8 : 1.0)
                        .cornerRadius(26)
                    }
                    .disabled(isLoading)
                    .padding(.horizontal, 24)
                    }
                //end wrap vstack  sign in and sign out button
                    
                // Social Login Buttons
                ZStack {
                    HStack(spacing: 24) {
                        // Google
                        Button(action: {
                            loginType = .google
                            googleSiginPopupVisible = true
                        })
                        {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 56, height: 56)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.6), lineWidth: 1)
                                    )
                                
                                
                                Image(systemName: "g.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .font(.system(size: 30))
                                    .foregroundColor(.red)
                                   
                            }
                        }
                        
//                        // Facebook
//                        Button(action: {
//                            loginType = .facebook
//                            googleSiginPopupVisible = true
//                        }) {
//                            ZStack {
//                                Circle()
//                                    .fill(Color.white)
//                                    .frame(width: 56, height: 56)
//
//                                Image(systemName: "f.circle.fill")
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                    .font(.system(size: 30))
//                                    .foregroundColor(.blue)
//                            }
//                        }
//
//                        // Apple
//                        Button(action: {
//                            loginType = .apple
//                            googleSiginPopupVisible = true
//                        }) {
//                            ZStack {
//                                Circle()
//                                    .fill(Color.white)
//                                    .frame(width: 56, height: 56)
//
//                                Image(systemName: "apple.logo")
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                    .font(.system(size: 30))
//                                    .foregroundColor(.black)
//                            }
//                        }
                    }
                    
                    // Hidden NavigationLink that triggers based on loginType
                    NavigationLink("", destination: destinationView(), isActive: $googleSiginPopupVisible)
                        .hidden()
                }
                .padding(.top, 32)
                
                // Sign Up Link
                VStack{
                    VStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(Colors.textSecondary)
                        
                        Button(action: {
                            isSignup = true
                        }) {
                            Text("Sign Up here")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "#FFB347"))
                        }
                    }
                    Spacer()
                }
               
                .padding(.top, 24)
                Spacer()
           
            }
        }
        .alert(isPresented: $showAlertNotCorrectPassword) {
            Alert(title: Text(""), message: Text("Please enter a valid email and password"), dismissButton: .default(Text("OK")))
        }
        .navigationBarHidden(true)
        }//close navigation stack
    }
}

#Preview {
    PopUpLoginView()
}

