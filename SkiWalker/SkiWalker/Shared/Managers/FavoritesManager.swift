//
//  FavoritesManager.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 21.01.25.
//

import Foundation

protocol FavoritesManagerProtocol {
    func fetchFavorites() async throws -> [Product]
    func addToFavorites(with productId: String) async throws
    func deleteFromFavorites(with productId: String) async throws
}

final class FAvoritesManager: FavoritesManagerProtocol {
    private let authenticatedRequestHanlder: AuthenticatedRequestHandlerProtocol
    
    init(authenticatedRequestHanlder: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler()) {
        self.authenticatedRequestHanlder = authenticatedRequestHanlder
    }
    
    func fetchFavorites() async throws -> [Product] {
        let url = "https://api.gargar.dev:8088/Product/favorites"
        
        let response: [Product]? = try await authenticatedRequestHanlder.sendRequest(urlString: url, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
        
        
        guard let products = response else {
            return []
        }
                
        return products
    }
    
    func addToFavorites(with productId: String) async throws {
        let url = "https://api.gargar.dev:8088/Product/\(productId)/favorites"
        
        let _: [Product]? = try await authenticatedRequestHanlder.sendRequest(urlString: url, method: .post, headers: nil, body: nil, decoder: JSONDecoder())
    }
    
    func deleteFromFavorites(with productId: String) async throws {
        let url = "https://api.gargar.dev:8088/Product/\(productId)/favorites"
        
        let _: [Product]? = try await authenticatedRequestHanlder.sendRequest(urlString: url, method: .delete, headers: nil, body: nil, decoder: JSONDecoder())
    }
}
