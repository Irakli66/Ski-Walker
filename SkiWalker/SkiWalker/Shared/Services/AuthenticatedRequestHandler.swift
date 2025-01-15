//
//  AuthenticatedRequestHandler.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 15.01.25.
//
import SwiftUI
import NetworkPackage

final class AuthenticatedRequestHandler {
    private let keyChainManager: KeyChainManagerProtocol
    private let networkService: NetworkServiceProtocol
    
    init(keyChainManager: KeyChainManagerProtocol = KeyChainManager(), networkService: NetworkServiceProtocol = NetworkService()) {
        self.keyChainManager = keyChainManager
        self.networkService = networkService
    }
    
    func sendRequest<T: Decodable>(urlString: String, method: HTTPMethod, headers: [String: String]? = nil, body: Data? = nil, decoder: JSONDecoder = JSONDecoder()) async throws -> T? {
            var headers = headers ?? [:]
            
            if let token = try? keyChainManager.getAccessToken() {
                headers["Authorization"] = "Bearer \(token)"
            } else {
                throw AuthError.accessTokenMissing
            }
            
            do {
                let response: T? =  try await networkService.request(urlString: urlString, method: method, headers: headers, body: body, decoder: decoder)
                return response
            } catch  {
                try await refreshAccessToken()
                
                if let newAccessToken = try? keyChainManager.getAccessToken() {
                    headers["Authorization"] = "Bearer \(newAccessToken)"
                    let response: T? = try await networkService.request(urlString: urlString, method: method, headers: headers, body: body, decoder: decoder)
                    return response
                } else {
                    throw AuthError.accessTokenMissing
                }
            }
            
        }
    
    func refreshAccessToken() async throws {
            do {
                guard let refreshToken = try? keyChainManager.getRefreshToken() else {
                    throw AuthError.refreshTokenMissing
                }
                
                let refreshRequestBody: [String: String] = ["refreshToken": refreshToken]
                
                guard let bodyData = try? JSONEncoder().encode(refreshRequestBody) else {
                    throw AuthError.invalidRequestBody
                }
                
                let response: LoginResponse? = try await networkService.request(
                    urlString: "https://api.gargar.dev:8088/refresh",
                    method: .post,
                    headers: ["Content-Type": "application/json"],
                    body: bodyData,
                    decoder: JSONDecoder()
                )
                
                try keyChainManager.storeAccessToken(accessToken: response?.accessToken ?? "")
            } catch {
                try keyChainManager.clearTokens()
                throw AuthError.tokenRefreshFailed
            }
        }
}

enum AuthError: Error {
    case accessTokenMissing
    case refreshTokenMissing
    case invalidRequestBody
    case tokenRefreshFailed
}
