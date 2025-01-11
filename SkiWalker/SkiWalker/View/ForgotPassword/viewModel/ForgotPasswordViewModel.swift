//
//  ForgotPasswordViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import Foundation

final class ForgotPasswordViewModel {
    
    func sendMailCode(with email: String) async throws {
        try validateEmail(email)
        print(email)
    }
    
    func updatePassword(email: String, mailCode: String, password: String, confirmPassword: String) async throws {
        guard !mailCode.isEmpty else {
            throw RecoverPasswordError.invalidMailCode
        }
        try validateEmail(email)
        try validatePassword(password)
        try validatePasswordMatch(password, confirmPassword)
        
        print(email, mailCode, password)
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

enum RecoverPasswordError: Error, LocalizedError {
    case invalidEmail
    case invalidMailCode
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email"
        case .invalidMailCode:
            return "Mail Code is empty"
        }
    }
}
