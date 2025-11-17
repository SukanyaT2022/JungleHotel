//
//  CustomAlertView.swift
//  JungleHotel
//
//  Created by TS2 on 11/10/25.
//
//  Custom alert components for showing success, error, and info messages
//
//  USAGE EXAMPLES:
//
//  1. Success Alert:
//     SuccessAlertView(
//         title: "Login Successful!",
//         message: "Welcome back!",
//         isPresented: $showSuccessAlert,
//         onDismiss: { /* optional action */ }
//     )
//
//  2. Error Alert:
//     ErrorAlertView(
//         title: "Login Failed",
//         message: "Invalid credentials",
//         isPresented: $showErrorAlert
//     )
//
//  3. Info Alert:
//     InfoAlertView(
//         title: "Information",
//         message: "Your session will expire soon",
//         isPresented: $showInfoAlert
//     )
//
//  4. Custom Alert:
//     CustomAlertView(
//         title: "Custom Title",
//         message: "Custom message",
//         icon: "star.fill",
//         iconColor: .orange,
//         isPresented: $showAlert
//     )

import SwiftUI

struct CustomAlertView: View {
    let title: String
    let message: String
    let icon: String
    let iconColor: Color
    @Binding var isPresented: Bool
    var onDismiss: (() -> Void)?
    
    var body: some View {
        ZStack {
            // Dimmed background
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isPresented = false
                            onDismiss?()
                        }
                    }
                
                // Alert Box
                VStack(spacing: 0) {
                    // Icon Section
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(iconColor.opacity(0.1))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: icon)
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(iconColor)
                        }
                        
                        Text(title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text(message)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 30)
                    
                    // OK Button
                    Button(action: {
                        withAnimation(.spring()) {
                            isPresented = false
                            onDismiss?()
                        }
                    }) {
                        Text("OK")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(iconColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                .frame(width: 320)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPresented)
    }
}

// Success Alert Variant
struct SuccessAlertView: View {
    let title: String
    let message: String
    @Binding var isPresented: Bool
    var onDismiss: (() -> Void)?
    
    var body: some View {
        CustomAlertView(
            title: title,
            message: message,
            icon: "checkmark.circle.fill",
            iconColor: .green,
            isPresented: $isPresented,
            onDismiss: onDismiss
        )
    }
}

// Error Alert Variant
struct ErrorAlertView: View {
    let title: String
    let message: String
    @Binding var isPresented: Bool
    var onDismiss: (() -> Void)?
    
    var body: some View {
        CustomAlertView(
            title: title,
            message: message,
            icon: "xmark.circle.fill",
            iconColor: .red,
            isPresented: $isPresented,
            onDismiss: onDismiss
        )
    }
}

// Info Alert Variant
struct InfoAlertView: View {
    let title: String
    let message: String
    @Binding var isPresented: Bool
    var onDismiss: (() -> Void)?
    
    var body: some View {
        CustomAlertView(
            title: title,
            message: message,
            icon: "info.circle.fill",
            iconColor: .blue,
            isPresented: $isPresented,
            onDismiss: onDismiss
        )
    }
}

#Preview {
    VStack {
        SuccessAlertView(
            title: "Login Successful!",
            message: "Welcome back! You have successfully signed in to your account.",
            isPresented: .constant(true)
        )
    }
}

