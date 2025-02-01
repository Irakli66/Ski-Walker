//
//  AddressValidationError.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 01.02.25.
//
import Foundation

enum AddressValidationError: Error, LocalizedError {
    case invalidCountry
    case invalidCity
    case invalidStreet
    case invalidPostalCode
    case invalidFullName
    case invalidRequestData
    
    var errorDescription: String? {
        switch self {
        case .invalidCountry:
            return "Fill the Country field."
        case .invalidCity:
            return "Fill the City field."
        case .invalidStreet:
            return "Fill the Street field."
        case .invalidPostalCode:
            return "Postal Code must be filled and contain only numbers."
        case .invalidFullName:
            return "Fill the Full Name field."
        case .invalidRequestData:
            return "Invalid request data."
        }
    }
}
