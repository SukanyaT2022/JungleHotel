//
//  PaymentMethodComp.swift
//  JungleHotel
//
//  Created by TS2 on 10/28/25.
//

import SwiftUI

struct PaymentMethodComp: View {
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    @Binding var cardNumber: String
    @State private var isPromotionChecked: Bool = false
    @FocusState.Binding var isKeyboardFocused: Bool
    
    //for pass data cradnumber to somewhere else we need init
    init(cardNumber: Binding<String> = .constant(""), isKeyboardFocused: FocusState<Bool>.Binding = FocusState<Bool>().projectedValue) {
        self._cardNumber = cardNumber
        self._isKeyboardFocused = isKeyboardFocused
    }
    
    enum PaymentMethod: String, CaseIterable, Hashable {
        case creditCard
        case digitalPayment
        case cryptoCurrency
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
         
            VStack(alignment: .leading, spacing: 20) {
                header
                cardSection
                Divider().padding(.vertical, 8)
                digitalSection
                Divider().padding(.vertical, 8)
                cryptoSection
                Divider().padding(.vertical, 8)
                promotionsSection
                termsSection
            }
            .padding(20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }//close scrollview
        .scrollDismissesKeyboard(.interactively)
        }
        
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var header: some View {
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
    }
    
    @ViewBuilder
    private var cardSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            RadioButtonView(
                title: "Credit/debit card",
                isSelected: selectedPaymentMethod == .creditCard,
                discountText: "Pay now 5% off"
            ) {
                selectedPaymentMethod = .creditCard
            }

            cardLogos

            if selectedPaymentMethod == .creditCard {
                cardNumberField
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
    
    @ViewBuilder
    private var cardLogos: some View {
        HStack(spacing: 12) {
            Image("visaCardInput")
                .resizable()
                .scaledToFit()
                .frame(height: 24)

            Image("masterCard")
                .resizable()
                .scaledToFit()
                .frame(height: 24)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.blue.opacity(0.1))
                .frame(width: 40, height: 24)
                .overlay(
                    Text("JCB")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.blue)
                )

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
    }
    
    @ViewBuilder
    private var cardNumberField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Credit/debit card number *")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading, 4)

            HStack(spacing: 12) {
                Image(systemName: "creditcard")
                    .foregroundColor(.gray)
                    .font(.system(size: 20))

                TextField("Card Number", text: $cardNumber)
                    .keyboardType(.asciiCapableNumberPad)
                    .focused($isKeyboardFocused)
                    .font(.body)
                    .foregroundColor(.primary)

                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .padding(.leading, 4)
        }
    }
    
    @ViewBuilder
    private var digitalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            RadioButtonView(
                title: "Digital payment",
                isSelected: selectedPaymentMethod == .digitalPayment,
                discountText: ""
            ) {
                selectedPaymentMethod = .digitalPayment
            }

            HStack(spacing: 12) {
                Image("paypalCard")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)

                Spacer()
            }
            .padding(.leading, 36)
        }
    }
    
    @ViewBuilder
    private var cryptoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            RadioButtonView(
                title: "Crypto payment",
                isSelected: selectedPaymentMethod == .cryptoCurrency,
                discountText: ""
            ) {
                selectedPaymentMethod = .cryptoCurrency
            }

            HStack(spacing: 12) {
                Text("Bitcoin | Ethereum | Ripple")
                Spacer()
            }
            .padding(.leading, 36)
        }
    }
    
    @ViewBuilder 
    private var promotionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                withAnimation {
                    isPromotionChecked.toggle()
                }
            }) {
                HStack(alignment: .top, spacing: 12) {
                    checkbox(isChecked: isPromotionChecked)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("I agree to receive updates and promotions about Agoda and its affiliates or business partners via various channels, including WhatsApp. Opt out anytime. Read more in the Privacy Policy.")
                            .font(.caption)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    private var termsSection: some View {
        VStack(spacing: 4) {
            Text("By proceeding with this booking, I agree to Agoda's")
                .font(.caption)
                .foregroundColor(.primary)
            Text("Terms of Use and Privacy Policy")
                .font(.caption)
                .foregroundColor(.blue)
                .underline()
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder
    private func checkbox(isChecked: Bool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .stroke(isChecked ? Color.blue : Color.gray, lineWidth: 2)
                .frame(width: 24, height: 24)

            if isChecked {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue)
                    .frame(width: 24, height: 24)

                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    ScrollView {
        PaymentMethodComp(cardNumber: .constant(""))
            .padding()
    }
    .background(Color(.systemGray6))
}

