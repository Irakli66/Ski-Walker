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
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
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
            LabeledTextFieldView(label: "Full Name", placeholder: "Enter your full name", text: $addressesViewModel.fullName)
            LabeledTextFieldView(label: "Country", placeholder: "Enter your country", text: $addressesViewModel.country)
            LabeledTextFieldView(label: "City", placeholder: "Enter your city", text: $addressesViewModel.city)
            LabeledTextFieldView(label: "Street", placeholder: "John Doe N25", text: $addressesViewModel.street)
            LabeledTextFieldView(label: "ZIP Code", placeholder: "", text: $addressesViewModel.postalCode)
                .frame(width: 80)
            Button(action: {
                Task {
                    do {
                        try await addressesViewModel.addAddress()
                        dismiss()
                    } catch {
                        AlertManager.showAlert(message: error.localizedDescription)
                    }
                }
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.customWhite)
                    .padding()
                    .background(Color.customPurple)
                    .cornerRadius(10)
                
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AddAddressView()
}
