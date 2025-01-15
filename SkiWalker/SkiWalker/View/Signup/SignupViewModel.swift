//
//  SignupViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import Foundation
import NetworkPackage

final class SignupViewModel {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
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
        
        let (url, requestBody): (String, [String: String]) = {
            switch userRole {
            case .customer:
                return ("https://api.gargar.dev:8088/Auth/registerUser", [
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                    "password": password
                ])
            case .vendor:
                return ("https://api.gargar.dev:8088/Auth/registerVendor", [
                    "companyName": companyName,
                    "companyId": companyID,
                    "email": email,
                    "password": password
                ])
            }
        }()
        
        guard let bodyData = try? JSONEncoder().encode(requestBody) else {
            throw SignupErrors.invalidRequestData
        }
        
        let _: SignupResponse? = try await networkService.request(
            urlString: url,
            method: .post,
            headers: nil,
            body: bodyData,
            decoder: JSONDecoder()
        )
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
enum UserRole: String, Hashable {
    case customer = "Customer"
    case vendor = "Vendor"
}
