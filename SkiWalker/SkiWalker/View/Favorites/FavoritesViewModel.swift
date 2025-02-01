//
//  FavoritesViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 21.01.25.
//
import Foundation

final class FavoritesViewModel {
    private let favoritesManager: FavoritesManagerProtocol
    private let cartManager: CartManagerProtocol
    private var favorites: [Product] = []
    var doneFetching: (() -> Void)?
    
    init(favoritesManager: FavoritesManagerProtocol = FAvoritesManager(), cartManager: CartManagerProtocol = CartManager()) {
        self.favoritesManager = favoritesManager
        self.cartManager = cartManager
    }
    
    func fetchFavorites() async {
        do {
            let response: [Product] = try await favoritesManager.fetchFavorites()
            favorites = response
        } catch {
            print(error.localizedDescription)
        }
        
        doneFetching?()
    }
    
    func addProductToCart(productId: String, count: Int = 1) async throws {
        do {
            try await cartManager.addProductToCart(productId: productId, count: count)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleFavorite(with id: String) async  {
        do {
            try await favoritesManager.deleteFromFavorites(with: id)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getFavoritesCount() -> Int {
        favorites.count
    }
    
    func getFavorite(at index: Int) -> Product {
        return favorites[index]
    }
}
