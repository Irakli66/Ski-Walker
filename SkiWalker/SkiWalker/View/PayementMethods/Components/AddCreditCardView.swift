//
//  AddCreditCardView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import SwiftUI

struct AddCreditCardView: View {
    @EnvironmentObject var viewModel: PaymentMethodsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var fullName: String = ""
    @State private var cardNumber: String = ""
    @State private var validThru: String = ""
    @State private var cvc: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.customWhite)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(Color.customPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.purple, .blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing))
                    .frame(height: 250)
                    .shadow(radius: 5)
                
                VStack(spacing: 15) {
                    LabeledTextFieldView(label: "Full Name", placeholder: "Enter your full name", text: $fullName)
                    
                    HStack(spacing: 10) {
                        LabeledTextFieldView(label: "Card Number", placeholder: "1234 5678 9012 3456", text: $cardNumber)
                            .frame(maxWidth: .infinity)
                        ValidThruTextField(label: "Valid Thru", placeholder: "MM/YY", text: $validThru)
                            .frame(width: 80)
                    }
                    
                    HStack(spacing: 10) {
                        Image(systemName: "creditcard")
                            .foregroundColor(.white)
                        Spacer()
                        LabeledTextFieldView(label: "CVC", placeholder: "123", text: $cvc)
                            .frame(width: 80)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            Button(action: {
                saveCreditCard()
            }) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.customWhite)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.customPurple)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
            }
        }
        .padding()
        .background(Color.customBackground)
    }
    
    private func saveCreditCard() {
        let newCard = CreditCard(fullName: fullName, number: cardNumber, validThru: validThru, cvc: cvc)
        Task {
            do {
                try await viewModel.addCreditCard(creditCard: newCard)
                dismiss()
            } catch let error as CreditCardValidationErrors {
                AlertManager.showAlert(message: error.localizedDescription)
            } catch {
                AlertManager.showAlert(message: "An unexpected error occurred. Please try again.")
            }
        }
    }
}


#Preview {
    AddCreditCardView()
}
