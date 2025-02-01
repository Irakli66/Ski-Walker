//
//  ForgotPasswordViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import Foundation
import NetworkPackage

final class ForgotPasswordViewModel {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func sendMailCode(with email: String) async throws {
        try validateEmail(email)
        
        let requestBody: [String: String] = [
            "email": email,
        ]
        
        guard let bodyData = try? JSONEncoder().encode(requestBody) else {
            throw LoginError.invalidCredentials
        }
        
        
        let _:User? = try await networkService.request(urlString: APIEndpoints.Auth.forgotPassword, method: .post, headers: nil, body: bodyData, decoder: JSONDecoder())
        
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
