//
//  AddAddressView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//

import SwiftUI

struct AddAddressView: View {
    @EnvironmentObject var addressesViewModel: AddressViewModel
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
                VStack (alignment: .leading, spacing: 10) {
                    LabeledTextFieldView(label: "Full Name", placeholder: "Enter your full name", text: $addressesViewModel.fullname)
                    
                    LabeledTextFieldView(label: "Country", placeholder: "Enter your country", text: $addressesViewModel.country)
                    
                    LabeledTextFieldView(label: "City", placeholder: "Enter your city", text: $addressesViewModel.city)
                    
                    LabeledTextFieldView(label: "Street", placeholder: "John Doe N25", text: $addressesViewModel.street)
                    
                    LabeledTextFieldView(label: "ZIP Code", placeholder: "", text: $addressesViewModel.postalCode)
                        .frame(maxWidth: 100)
                    
                    Button(action: {
                        Task {
                            do {
                                try await addressesViewModel.addAddress()
                                try await addressesViewModel.fetchAddresses()
                                dismiss()
                            } catch let error as AddressValidationError {
                                showAlert = true
                                alertMessage = error.localizedDescription
                            } catch {
                                showAlert = true
                                alertMessage = error.localizedDescription
                            }
                        }
                    }) {
                        Text("Save")
                            .buttonModifier()
                        
                    }
                    Spacer()
                }
                .padding(.horizontal, 5)
            }
        }
        .padding()
        .customAlert(isPresented: $showAlert, title: "Validation Error", message: alertMessage)
    }
}

#Preview {
    AddAddressView()
}
