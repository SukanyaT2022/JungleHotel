//
//  SwiftUIView.swift
//  JungleHotel
//
//  Created by TS2 on 11/25/25.
//

import SwiftUI

struct InputCompView: View {
    let textLabel: String
    @Binding var textValue: String
    var placeholder: String = ""
    var isRequired: Bool = true
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var icon: String? = nil
    var showPasswordToggle: Bool = false
    @State private var isPasswordVisible: Bool = false
    var enableEditing: Bool = true
    
    // Initializer for external binding
    init(
        textLabel: String,
        textValue: Binding<String>,
        placeholder: String = "",
        isRequired: Bool = true,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        icon: String? = nil,
        showPasswordToggle: Bool = false,
        enableEditing: Bool = true
    ) {
        self.textLabel = textLabel
        self._textValue = textValue
        self.placeholder = placeholder.isEmpty ? textLabel : placeholder
        self.isRequired = isRequired
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.icon = icon
        self.showPasswordToggle = showPasswordToggle
        self.enableEditing = enableEditing
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 2) {
                Text(textLabel)
                    .font(.system(size: 14))
                if isRequired {
                    Text("*")
                        .foregroundStyle(.red)
                }
            }
            
            HStack(spacing: 12) {
                // Optional leading icon
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
                
                // Text field or secure field
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $textValue)
                        .textFieldStyle(.plain)
                        .keyboardType(keyboardType)
                        .autocapitalization(keyboardType == .emailAddress ? .allCharacters : .sentences)
                    //for edit file
                        .disabled(!enableEditing)
                } else {
                    TextField(placeholder, text: $textValue)
                        .textFieldStyle(.plain)
                        .keyboardType(keyboardType)
                        .autocapitalization(keyboardType == .emailAddress ? .allCharacters : .sentences)
                    //for edit file
                        .disabled(!enableEditing)
                }
                
                // Password visibility toggle
                if showPasswordToggle && isSecure {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 45)
            .background(Color.gray.opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .cornerRadius(10)
        }//close v stack
    }
}

#Preview {
    VStack(spacing: 20) {
        InputCompView(
            textLabel: "Email",
            textValue: .constant(""),
            placeholder: "Enter your email",
            icon: "envelope"
        )
        
        InputCompView(
            textLabel: "Password",
            textValue: .constant(""),
            placeholder: "Enter your password",
            isSecure: true,
            icon: "lock",
            showPasswordToggle: true
        )
        
        InputCompView(
            textLabel: "Phone",
            textValue: .constant(""),
            placeholder: "Enter phone number",
            isRequired: false,
            keyboardType: .phonePad,
            icon: "phone"
        )
    }
    .padding()
}
