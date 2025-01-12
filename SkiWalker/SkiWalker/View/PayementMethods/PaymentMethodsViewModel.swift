//
//  PaymentMethodsViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import SwiftUI

final class PaymentMethodsViewModel: ObservableObject {
    @Published var paymentMethods: [CreditCard] = [
        CreditCard(fullName: "John Does", number: "1234 5678 9012 3456", validThru: "26/30", cvc: "363"),
        CreditCard(fullName: "John Does", number: "1235 5678 9012 3456", validThru: "26/30", cvc: "363"),
        CreditCard(fullName: "John Does", number: "1236 5678 9012 3456", validThru: "26/30", cvc: "363")
    ]
    
    func addCreditCard(creditCard: CreditCard) {
        paymentMethods.append(creditCard)
    }
    
    func removeCreditCard(with id: UUID) {
        paymentMethods.removeAll { $0.id == id }
    }
}

struct CreditCard {
    let id: UUID = UUID()
    let fullName: String
    let number: String
    let validThru: String
    let cvc: String
}
