//
//  SetNewPasswordViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 30.01.25.
//
import Foundation
import NetworkPackage

final class SetNewPasswordViewModel {
    private let netoworkService: NetworkServiceProtocol
    
    init(netoworkService: NetworkServiceProtocol = NetworkService()) {
        self.netoworkService = netoworkService
    }
    
    func updatePassword(email: String, mailCode: String, password: String, confirmPassword: String) async throws {
        guard !mailCode.isEmpty else {
            throw RecoverPasswordError.invalidMailCode
        }
        try validateEmail(email)
        try validatePassword(password)
        try validatePasswordMatch(password, confirmPassword)
        
        let requestBody: [String: String] = [
            "email": email,
            "resetCode": mailCode,
            "newPassword": password
        ]
        
        guard let bodyData = try? JSONEncoder().encode(requestBody) else {
            throw LoginError.invalidCredentials
        }
        
        let _: User? = try await netoworkService.request(urlString: APIEndpoints.Auth.resetPassword, method: .post, headers: nil, body: bodyData, decoder: JSONDecoder())
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
