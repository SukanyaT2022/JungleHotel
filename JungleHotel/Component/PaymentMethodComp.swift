//
//  PaymentMethodComp.swift
//  JungleHotel
//
//  Created by TS2 on 10/28/25.
//

import SwiftUI

struct PaymentMethodComp: View {
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    @Binding var cardNumber: String = .constant("")
    @State private var isPromotionChecked: Bool = false
    
    
    enum PaymentMethod {
        case creditCard
        case digitalPayment
        case cyptoCurrency
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Payment method")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 6) {
                    Image(systemName: "shield.checkered")
                        .foregroundColor(.green)
                        .font(.system(size: 14))
                    
                    Text("All payment data is encrypted and secure")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
            }
            .padding(.bottom, 8)
            
            // Credit/Debit Card Option
            VStack(alignment: .leading, spacing: 16) {
                RadioButtonView(
                    title: "Credit/debit card",
                    isSelected: selectedPaymentMethod == .creditCard, discountText: "Pay now 5% off"
                    //.creditcard from enum
                ) {
                    selectedPaymentMethod = .creditCard
                }
                
                // Card Logos
                HStack(spacing: 12) {
                    Image("visaCardInput")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 24)
                    
                    Image("masterCard")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 24)
                    
                    // JCB placeholder (using SF Symbol)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 40, height: 24)
                        .overlay(
                            Text("JCB")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.blue)
                        )
                    
                    // Amex placeholder (using SF Symbol)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 40, height: 24)
                        .overlay(
                            Image(systemName: "creditcard.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        )
                    
                    Spacer()
                }
                .padding(.leading, 36)
                
                // Card Number Input Field
                if selectedPaymentMethod == .creditCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Credit/debit card number *")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.leading, 36)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "creditcard")
                                .foregroundColor(.gray)
                                .font(.system(size: 20))
                            
                            TextField("Card Number", text: $cardNumber)
                                .keyboardType(.numberPad)
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.leading, 36)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            
            Divider()
                .padding(.vertical, 8)
            
            // Digital Payment Option
            VStack(alignment: .leading, spacing: 16) {
                RadioButtonView(
                    title: "Digital payment",
                    isSelected: selectedPaymentMethod == .digitalPayment, discountText: ""
                ) {
                    selectedPaymentMethod = .digitalPayment
                }
                
                // PayPal Logo
                HStack(spacing: 12) {
                    Image("paypalCard")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    
                    Spacer()
                }
                .padding(.leading, 36)
            }
            
            Divider()
                .padding(.vertical, 8)
            // cypto Payment Option
            VStack(alignment: .leading, spacing: 16) {
                RadioButtonView(
                    title: "Cypto payment",
                    isSelected: selectedPaymentMethod == .cyptoCurrency, discountText: ""
                ) {
                    selectedPaymentMethod = .cyptoCurrency
                }
                
                // PayPal Logo
                HStack(spacing: 12) {
                    Text("Bitcoin | Etherium | Ripple")
                    
                    Spacer()
                }
                .padding(.leading, 36)
            }
            
            Divider()
                .padding(.vertical, 8)
            
            
            // Promotional Checkbox
            VStack(alignment: .leading, spacing: 12) {
                Button(action: {
                    withAnimation {
                        isPromotionChecked.toggle()
                    }
                }) {
                    HStack(alignment: .top, spacing: 12) {
                        // Checkbox
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(isPromotionChecked ? Color.blue : Color.gray, lineWidth: 2)
                                .frame(width: 24, height: 24)
                            
                            if isPromotionChecked {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.blue)
                                    .frame(width: 24, height: 24)
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Text
                        VStack(alignment: .leading, spacing: 4) {
                            Text("I agree to receive updates and promotions about Agoda and its affiliates or business partners via various channels, including WhatsApp. Opt out anytime. Read more in the Privacy Policy.")
                                .font(.caption)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .buttonStyle(.plain)
                
                // Terms and Privacy Policy
               VStack(spacing: 4) {
                    Text("By proceeding with this booking, I agree to Agoda's")
                        .font(.caption)
                        .foregroundColor(.primary)
            
                        
                        Text("Terms of Use and Privacy Policy")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .underline()
                
                }//close vstack
                .fixedSize(horizontal: false, vertical: true)
            }
        }

        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    ScrollView {
        PaymentMethodComp()
            .padding()
    }
    .background(Color(.systemGray6))
}


