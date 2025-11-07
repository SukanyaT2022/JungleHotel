//
//  PopUpLoginView.swift
//  JungleHotel
//
//  Created by TS2 on 11/7/25.
//

import SwiftUI

struct PopUpLoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var showPassword: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
                    
                    // Email Field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        TextField("example@gmail.com", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .font(.system(size: 15))
                        
                        if !email.isEmpty {
                            Button(action: {
                                // Email verified action
                            }) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.5))
                            }
                        }
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
                        // Sign in action
                    }) {
                        Text("Sign in")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.2, green: 0.3, blue: 0.5))
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
                .background(Color.white)
                .cornerRadius(30)
                .padding(.horizontal, 24)
                
                // Social Login Buttons
                HStack(spacing: 20) {
                    // Google
                    Button(action: {
                        // Google sign in
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 56, height: 56)
                            
                            Image(systemName: "g.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Facebook
                    Button(action: {
                        // Facebook sign in
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 56, height: 56)
                            
                            Image(systemName: "f.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // Apple
                    Button(action: {
                        // Apple sign in
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 56, height: 56)
                            
                            Image(systemName: "apple.logo")
                                .font(.system(size: 28))
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.top, 32)
                
                // Sign Up Link
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Button(action: {
                        // Sign up action
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
        .navigationBarHidden(true)
    }
}

#Preview {
    PopUpLoginView()
}
