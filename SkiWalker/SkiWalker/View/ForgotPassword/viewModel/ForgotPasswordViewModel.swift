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
    
    private func validateEmail(_ email: String) throws {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            throw SignupErrors.invalidEmail
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
