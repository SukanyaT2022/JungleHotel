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
    case facebook
    case apple
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
        case .facebook:
            Text("Facebook Login View")
                .font(.title)
        case .apple:
            Text("Apple Login View")
                .font(.title)
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
            Color(red: 0.2, green: 0.3, blue: 0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Back Button
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                .padding(.top, 50)
                
                Spacer()
                    .frame(height: 20)
                
                // White Card Container
                VStack(spacing: 24) {
                    // Logo
                    VStack(spacing: 16) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color.orange)
                            .overlay(
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(Color.blue)
                                    .rotationEffect(.degrees(180))
                                    .offset(x: 20, y: 0)
                            )
                        
                        Text("Jungle Hotel")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .tracking(2)
                    }
                    .padding(.top, 40)
                    
                    // Auth error message
                    if let authErrorMessage {
                        Text(authErrorMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    
                    // Email Field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        TextField("Enter your email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .font(.system(size: 15))
                    }
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                    
                    // Password Field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
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
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                    
                    // Remember Me and Forgot Password
                    HStack {
                        Button(action: {
                            rememberMe.toggle()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                    .foregroundColor(rememberMe ? Color(red: 0.2, green: 0.3, blue: 0.5) : .gray)
                                    .font(.system(size: 18))
                                
                                Text("Remember me")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Forgot password action
                        }) {
                            Text("Forgot password")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 24)
                    
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
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.2, green: 0.3, blue: 0.5))
                        .opacity(isLoading ? 0.8 : 1.0)
                        .cornerRadius(25)
                    }
                    .disabled(isLoading)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                    
                    // Sign Up Button (create account)
                    NavigationLink("", destination: SignUpView(), isActive: $isSignup)
                    Button(action: {
                        if !isLoading {
                        isSignup = true
                        }
                    }) {
                        Text(isLoading ? "Creating account..." : "Sign up")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.5))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .cornerRadius(25)
                    }
                    .disabled(isLoading)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
                .background(Color.white)
                .cornerRadius(30)
                .padding(.horizontal, 24)
                
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
                                    .fill(Color.white)
                                    .frame(width: 56, height: 56)
                                
                                
                                Image(systemName: "g.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .font(.system(size: 30))
                                    .foregroundColor(.red)
                                   
                            }
                        }
                        
                        // Facebook
                        Button(action: {
                            loginType = .facebook
                            googleSiginPopupVisible = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 56, height: 56)
                                
                                Image(systemName: "f.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        // Apple
                        Button(action: {
                            loginType = .apple
                            googleSiginPopupVisible = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 56, height: 56)
                                
                                Image(systemName: "apple.logo")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .font(.system(size: 30))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    
                    // Hidden NavigationLink that triggers based on loginType
                    NavigationLink("", destination: destinationView(), isActive: $googleSiginPopupVisible)
                        .hidden()
                }
                .padding(.top, 32)
                
                // Sign Up Link
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Button(action: {
                        isSignup = true
                    }) {
                        Text("Sign Up here")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.orange)
                    }
                }
                .padding(.top, 20)
                
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

