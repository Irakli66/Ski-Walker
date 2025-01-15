//
//  SignupResponse.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 15.01.25.
//
import Foundation

struct SignupResponse: Decodable {
    let code: String
    let description: String
}

enum SignupErrors: Error, LocalizedError {
    case invalidFirstName
    case invalidLastName
    case invalidCompanyName
    case inValidCompanyID
    case invalidEmail
    case invalidPassword
    case passwordsDontMatch
    case invalidRequestData
    case custom(message: String)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidFirstName:
            return "First name cannot be empty."
        case .invalidLastName:
            return "Last name cannot be empty."
        case .invalidCompanyName:
            return "Company name cannot be empty."
        case .inValidCompanyID:
            return "Company ID cannot be empty."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .invalidPassword:
            return "Password must be at least 6 characters long, contain at least 1 uppercase letter, and 1 special character."
        case .passwordsDontMatch:
            return "Passwords do not match."
        case .invalidRequestData:
            return "Invalid request data."
        case .custom(let message):
            return message

        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
