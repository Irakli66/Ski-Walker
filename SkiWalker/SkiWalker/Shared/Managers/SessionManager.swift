//
//  SessionManager.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 14.01.25.
//
import SwiftUI

protocol SessionManagerProtocol {
    func checkLoginStatus()
    func logout()
    func login(refreshToken: String, accessToken: String)
}

final class SessionManager: ObservableObject, SessionManagerProtocol {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    private let keychainManager: KeyChainManagerProtocol

    init(keychainManager: KeyChainManagerProtocol = KeyChainManager()) {
        self.keychainManager = keychainManager
        checkLoginStatus()
    }

    func checkLoginStatus() {
        if let token = try? keychainManager.getRefreshToken(), !token.isEmpty {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }

    func logout() {
        try? keychainManager.clearTokens()
        isLoggedIn = false
    }

    func login(refreshToken: String, accessToken: String) {
        try? keychainManager.storeTokens(accessToken: accessToken, refreshToken: refreshToken)
        isLoggedIn = true
    }
}
