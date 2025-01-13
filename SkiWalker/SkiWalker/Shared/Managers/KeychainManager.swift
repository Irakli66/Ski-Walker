//
//  KeychainManager.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 13.01.25.
//
import Foundation
import Security

protocol KeyChainManagerProtocol {
    func storeTokens(accessToken: String, refreshToken: String) throws
    func storeAccessToken(accessToken: String) throws
    func storeUserRole(userRole: String) throws
    func getRefreshToken() throws -> String
    func getAccessToken() throws -> String
    func getUserRole() throws -> String
    func clearTokens() throws
}

enum KeychainError: Error {
    case unexpectedData
    case unhandledError(status: OSStatus)
    case itemNotFound
}

final class KeyChainManager: KeyChainManagerProtocol {
    
    private func createQuery(forKey key: String) -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: Bundle.main.bundleIdentifier ?? "com.default.service"
        ]
    }
    
    private func save(_ value: String, forKey key: String) throws {
        var query = createQuery(forKey: key)
        let data = value.data(using: .utf8)!
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            let attributesToUpdate = [kSecValueData as String: data]
            let updateStatus = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if updateStatus != errSecSuccess {
                throw KeychainError.unhandledError(status: updateStatus)
            }
        } else if status == errSecItemNotFound {
            query[kSecValueData as String] = data
            let addStatus = SecItemAdd(query as CFDictionary, nil)
            if addStatus != errSecSuccess {
                throw KeychainError.unhandledError(status: addStatus)
            }
        } else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    private func read(forKey key: String) throws -> String {
        var query = createQuery(forKey: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        
        guard let data = result as? Data, let stringValue = String(data: data, encoding: .utf8) else {
            throw KeychainError.unexpectedData
        }
        
        return stringValue
    }
    
    private func delete(forKey key: String) throws {
        let query = createQuery(forKey: key)
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func storeTokens(accessToken: String, refreshToken: String) throws {
        try save(accessToken, forKey: "accessToken")
        try save(refreshToken, forKey: "refreshToken")
    }
    
    func storeAccessToken(accessToken: String) throws {
        try save(accessToken, forKey: "accessToken")
    }
    
    func storeUserRole(userRole: String) throws {
        try save("\(userRole)", forKey: "userRole")
    }
    
    func getRefreshToken() throws -> String {
        return try read(forKey: "refreshToken")
    }
    
    func getAccessToken() throws -> String {
        return try read(forKey: "accessToken")
    }
    
    func getUserRole() throws -> String {
        let userRole = try read(forKey: "userRole")
        return userRole
    }
    
    func clearTokens() throws {
        try delete(forKey: "accessToken")
        try delete(forKey: "refreshToken")
    }
}
