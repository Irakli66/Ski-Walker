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
    
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        VStack {
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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.purple, .blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing))
                            .frame(height: 250)
                            .shadow(radius: 5)
                        
                        VStack(spacing: 15) {
                            LabeledTextFieldView(label: "Full Name", placeholder: "Enter your full name", text: $viewModel.fullname)
                            
                            HStack(spacing: 10) {
                                LabeledTextFieldView(label: "Card Number", placeholder: "1234 5678 9012 3456", text: $viewModel.cardNumber)
                                    .frame(maxWidth: .infinity)
                                ValidThruTextField(label: "Valid Thru", placeholder: "MM/YY", text: $viewModel.validThru)
                                    .frame(width: 80)
                            }
                            
                            HStack(spacing: 10) {
                                Image(systemName: "creditcard")
                                    .foregroundColor(.white)
                                Spacer()
                                LabeledTextFieldView(label: "CVC", placeholder: "123", text: $viewModel.cvc)
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
                            .buttonModifier()
                    }
                }
            }
        }
        .padding()
        .background(Color.customBackground)
        .customAlert(isPresented: $showAlert, title: "Validation Error", message: alertMessage)
    }
    
    private func saveCreditCard() {
        Task {
            do {
                try await viewModel.addCreditCard()
                try await viewModel.fetchPaymentMethods()
                dismiss()
            } catch let error as CreditCardValidationErrors {
                alertMessage = error.localizedDescription
                showAlert = true
            } catch {
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}
