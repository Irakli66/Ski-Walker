//
//  CartViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 20.01.25.
//
import Foundation

final class CartViewModel {
    private let cartManager: CartManagerProtocol
    private let favoritesManager: FavoritesManagerProtocol
    private var cartItems: [CartItem] = []
    var doneFetching: (() -> Void)?
    
    init(cartManager: CartManagerProtocol = CartManager(), favoritesManager: FavoritesManagerProtocol = FAvoritesManager()) {
        self.cartManager = cartManager
        self.favoritesManager = favoritesManager
    }
    
    func fetchCart() async  {
        do {
            let response: [CartItem] = try await cartManager.fetchCartItems()
            cartItems = response
        } catch {
            print(error.localizedDescription)
        }
        doneFetching?()
    }
    
    func updateProduct(productId: String, count: Int) async throws {
        do {
            try await cartManager.addProductToCart(productId: productId, count: count)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteCartItem(with id: String) async throws {
        do {
            try await cartManager.deleteProductFromCart(productId: id)
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
    
    func removeFromFavorites(with id: String) async {
        do {
            try await favoritesManager.deleteFromFavorites(with: id)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getCartItemsCount() -> Int {
        return cartItems.count
    }
    
    func getCartItem(at index: Int) -> CartItem {
        return cartItems[index]
    }
    
    func getCartTotalItemCount() -> Int {
        return cartItems.reduce(0) { $0 + $1.count }
    }
    
    func getTotalPriceFormatted() -> String {
        let totalPrice = cartItems.reduce(0) { $0 + Double($1.count) * $1.product.finalPrice }
        return CurrencyFormatter.formatPriceToGEL(totalPrice)
    }
}
