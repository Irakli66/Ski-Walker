//
//  SignupViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import Foundation

final class SignupViewModel {
    
    func register(firstName: String = "", lastName: String = "", companyName: String = "", companyID: String = "", email: String = "", password: String = "", confirmPassword: String = "", userRole: UserRole) async throws {
        
        switch userRole {
        case .customer:
            try validateName(firstName, error: .invalidFirstName)
            try validateName(lastName, error: .invalidLastName)
        case .vendor:
            try validateName(companyName, error: .invalidCompanyName)
            try validateName(companyID, error: .inValidCompanyID)
        }
        
        try validateEmail(email)
        try validatePassword(password)
        try validatePasswordMatch(password, confirmPassword)
        
        if userRole == .customer {
            print(firstName, lastName, email, password)
        } else {
            print(companyName, companyID, email, password)
        }
    }
    
    private func validateName(_ name: String, error: SignupErrors) throws {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw error
        }
    }
    
    private func validateEmail(_ email: String) throws {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            throw SignupErrors.invalidEmail
        }
    }
    
    private func validatePassword(_ password: String) throws {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])[A-Za-z\\d!@#$&*]{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        if !passwordPredicate.evaluate(with: password) {
            throw SignupErrors.invalidPassword
        }
    }
    
    private func validatePasswordMatch(_ password: String, _ confirmPassword: String) throws {
        if password != confirmPassword {
            throw SignupErrors.passwordsDontMatch
        }
    }
}

enum SignupErrors: Error, LocalizedError {
    case invalidFirstName
    case invalidLastName
    case invalidCompanyName
    case inValidCompanyID
    case invalidEmail
    case invalidPassword
    case passwordsDontMatch
    
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
        }
    }
}

enum UserRole: String, Hashable {
    case customer = "Customer"
    case vendor = "Vendor"
}
