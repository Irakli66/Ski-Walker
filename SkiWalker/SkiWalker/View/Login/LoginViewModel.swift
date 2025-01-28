//
//  LoginViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import UIKit
import NetworkPackage

final class LoginViewModel {
    private let sessionManager: SessionManagerProtocol
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(), sessionManager: SessionManagerProtocol) {
        self.networkService = networkService
        self.sessionManager = sessionManager
    }
    
    func login(email: String, password: String) async throws {
        let url = "https://api.gargar.dev:8088/login"
        
        guard !email.isEmpty && email.contains("@") else {
            throw LoginError.invalidEmail
        }
        
        guard !password.isEmpty else {
            throw LoginError.invalidPassword
        }
        
        let requestBody: [String: String] = [
            "email": email,
            "password": password
        ]
        
        guard let bodyData = try? JSONEncoder().encode(requestBody) else {
            throw LoginError.invalidCredentials
        }
        
        do {
            let response: LoginResponse? = try await networkService.request(
                urlString: url,
                method: .post,
                headers: ["Content-Type": "application/json"],
                body: bodyData,
                decoder: JSONDecoder()
            )
            guard let response else {
                throw LoginError.invalidCredentials
            }
            
           await sessionManager.login(refreshToken: response.refreshToken, accessToken: response.accessToken)
            
        } catch {
            throw error
        }
    }
}
