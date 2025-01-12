//
//  AddressViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import Foundation

final class AddressViewModel: ObservableObject {
    @Published var addresses: [Address] = [Address(id: UUID().uuidString, country: "Georgia", city: "Tbilisi", street: "25 merab kostava", postalCode: "0236", fullName: "John Doe")]
}
