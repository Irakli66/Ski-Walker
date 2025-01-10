//
//  LoginViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import UIKit

final class LoginViewModel {
    
    func login(email: String, password: String) async throws {
        guard !email.isEmpty && email.contains("@") else {
            throw LoginError.invalidEmail
        }
        
        guard !password.isEmpty else {
            throw LoginError.invalidPassword
        }
        
        print(email, password)
    }
}



enum LoginError: Error {
    case invalidEmail
    case invalidPassword
}
