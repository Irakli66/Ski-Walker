//
//  AddAddressView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//

import SwiftUI

struct AddAddressView: View {
    @EnvironmentObject var addressesViewModel: AddressViewModel
    let options = ["Georgia", "Germany", "USA", "Mexico", "Japan", "Sweden"]
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            LabeledTextFieldView(label: "Full Name", placeholder: "Enter your full name", text: $addressesViewModel.fullName)
            LabeledTextFieldView(label: "Country", placeholder: "Enter your country", text: $addressesViewModel.country)
            LabeledTextFieldView(label: "City", placeholder: "Enter your city", text: $addressesViewModel.city)
            LabeledTextFieldView(label: "Street", placeholder: "John Doe N25", text: $addressesViewModel.street)
            LabeledTextFieldView(label: "ZIP Code", placeholder: "", text: $addressesViewModel.postalCode)
                .frame(width: 80)
            Button(action: {
                addressesViewModel.addAddress()
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
