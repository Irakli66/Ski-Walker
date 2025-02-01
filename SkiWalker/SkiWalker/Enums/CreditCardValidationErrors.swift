//
//  CreditCardValidationErrors.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 01.02.25.
//
import Foundation

enum CreditCardValidationErrors: Error, LocalizedError {
    case invalidFullName
    case invalidNumber
    case invalidValidThru
    case invalidCvc
    case invalidRequestData
    
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
        case .invalidRequestData:
            return "Invalid request data."
        }
    }
}
