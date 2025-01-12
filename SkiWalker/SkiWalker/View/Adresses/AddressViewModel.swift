//
//  AddressViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import Foundation

final class AddressViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var country: String = ""
    @Published var city: String = ""
    @Published var street: String = ""
    @Published var postalCode: String = ""
    @Published var addresses: [Address] = [Address(id: UUID().uuidString, country: "Georgia", city: "Tbilisi", street: "25 merab kostava", postalCode: "0236", fullName: "John Doe")]
    
    func addAddress() {
        let newAddress = Address(id: UUID().uuidString, country: country, city: city, street: street, postalCode: postalCode, fullName: fullName)
        addresses.append(newAddress)
    }
    
    func removeAddress(_ address: Address) {
        addresses.removeAll(where: { $0.id == address.id })
    }
}
