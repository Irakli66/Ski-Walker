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
    
    func addAddress() async throws {
        let newAddress = Address(id: UUID().uuidString, country: country, city: city, street: street, postalCode: postalCode, fullName: fullName)
        
        try validateAddress(newAddress)
        
        await MainActor.run {
            addresses.append(newAddress)
        }
    }
    
    func removeAddress(_ address: Address) {
        addresses.removeAll(where: { $0.id == address.id })
    }
    
    private func validateAddress(_ address: Address) throws {
        if address.fullName.trimmingCharacters(in: .whitespaces).isEmpty {
            throw AddressValidationError.invalidFullName
        }
        if address.country.trimmingCharacters(in: .whitespaces).isEmpty {
            throw AddressValidationError.invalidCountry
        }
        if address.city.trimmingCharacters(in: .whitespaces).isEmpty {
            throw AddressValidationError.invalidCity
        }
        if address.street.trimmingCharacters(in: .whitespaces).isEmpty {
            throw AddressValidationError.invalidStreet
        }
        if address.postalCode.trimmingCharacters(in: .whitespaces).isEmpty || !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: address.postalCode)) {
            throw AddressValidationError.invalidPostalCode
        }
    }
}
