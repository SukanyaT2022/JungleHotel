//
//  AlertDemoView.swift
//  JungleHotel
//
//  Created by TS2 on 11/10/25.
//
//  Demo view to showcase all alert types

import SwiftUI

struct AlertDemoView: View {
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var showInfoAlert = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                Text("Alert Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Success Alert Button
                Button(action: {
                    showSuccessAlert = true
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Show Success Alert")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Error Alert Button
                Button(action: {
                    showErrorAlert = true
                }) {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                        Text("Show Error Alert")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Info Alert Button
                Button(action: {
                    showInfoAlert = true
                }) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                        Text("Show Info Alert")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            
            // Alert Overlays
            if showSuccessAlert {
                SuccessAlertView(
                    title: "Login Successful!",
                    message: "Welcome back! You have successfully signed in to your account.",
                    isPresented: $showSuccessAlert
                )
            }
            
            if showErrorAlert {
                ErrorAlertView(
                    title: "Login Failed",
                    message: "Invalid email or password. Please try again.",
                    isPresented: $showErrorAlert
                )
            }
            
            if showInfoAlert {
                InfoAlertView(
                    title: "Information",
                    message: "This is an informational message to notify you about something important.",
                    isPresented: $showInfoAlert
                )
            }
        }
    }
}

#Preview {
    AlertDemoView()
}






