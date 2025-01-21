//
//  ProductDetailsViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 18.01.25.
//
import SwiftUI
import NetworkPackage

final class ProductDetailsViewModel: ObservableObject {
    private let authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol
    private let cartManager: CartManagerProtocol
    private let favoritesManager: FavoritesManagerProtocol
    @Published var product: Product?
    
    init(authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler(), cartManager: CartManagerProtocol = CartManager(), favoritesManager: FavoritesManagerProtocol = FAvoritesManager()) {
        self.authenticatedRequestHandler = authenticatedRequestHandler
        self.cartManager = cartManager
        self.favoritesManager = favoritesManager
    }
    
    func fetchProduct(with id: String) async throws {
        let url = "https://api.gargar.dev:8088/Product/\(id)"
        
        let response: Product? = try await authenticatedRequestHandler.sendRequest(urlString: url, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
        
        await MainActor.run {
            product = response
        }
    }
    
    func addProductToCart(productId: String, count: Int) async throws {
        do {
            try await cartManager.addProductToCart(productId: productId, count: count)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addToFavorites(with id: String) async {
        do {
            try await favoritesManager.addToFavorites(with: id)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteFromFavorites(with id: String) async {
        do {
            try await favoritesManager.deleteFromFavorites(with: id)
        } catch {
            print(error.localizedDescription)
        }
    }
}
