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
    
    func addCreditCard(creditCard: CreditCard) async throws {
        try validateCreditCard(creditCard)
        await MainActor.run {
            paymentMethods.append(creditCard)
        }
    }
    
    func removeCreditCard(with id: UUID) {
        paymentMethods.removeAll { $0.id == id }
    }
    
    private func validateCreditCard(_ card: CreditCard) throws {
        if card.fullName.trimmingCharacters(in: .whitespaces).count < 2 {
            throw CreditCardValidationErrors.invalidFullName
        }
        
        let cleanedNumber = card.number.replacingOccurrences(of: " ", with: "")
        if cleanedNumber.count != 16 || !cleanedNumber.allSatisfy({ $0.isNumber }) {
            throw CreditCardValidationErrors.invalidNumber
        }
        
        let components = card.validThru.split(separator: "/")
        if components.count == 2,
           let month = Int(components[0]),
           let year = Int(components[1]),
           (1...12).contains(month) {
            
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date()) % 100 // Get last two digits of the current year
            let currentMonth = calendar.component(.month, from: Date())
            
            if year < currentYear || (year == currentYear && month < currentMonth) {
                throw CreditCardValidationErrors.invalidValidThru
            }
        } else {
            throw CreditCardValidationErrors.invalidValidThru
        }
        
        if card.cvc.count < 3 || card.cvc.count > 4 || !card.cvc.allSatisfy({ $0.isNumber }) {
            throw CreditCardValidationErrors.invalidCvc
        }
    }
}

enum CreditCardValidationErrors: Error, LocalizedError {
    case invalidFullName
    case invalidNumber
    case invalidValidThru
    case invalidCvc
    
    var errorDescription: String? {
        switch self {
        case .invalidFullName:
            return "Full name must be at least 2 characters long."
        case .invalidNumber:
            return "Credit card number must be exactly 16 digits long."
        case .invalidValidThru:
            return "Credit card expiration date must be in the future."
        case .invalidCvc:
            return "Credit card CVC must be 3 or 4 digits long."
        }
    }
}
