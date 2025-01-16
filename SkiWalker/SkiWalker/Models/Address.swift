//
//  Address.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import Foundation

struct Address: Codable {
    let id: String
    let country: String
    let city: String
    let street: String
    let postalCode: String
    let fullname: String
}

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
