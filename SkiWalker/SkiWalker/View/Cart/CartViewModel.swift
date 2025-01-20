//
//  CartViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 20.01.25.
//
import Foundation

final class CartViewModel {
    private let cartManager: CartManagerProtocol
    private var cartItems: [CartItem] = []
    
    init(cartManager: CartManagerProtocol = CartManager()) {
        self.cartManager = cartManager
    }
    
    func fetchCart() async  {
        do {
            let response: [CartItem] = try await cartManager.fetchCartItems()
            cartItems = response
        } catch {
            print(error.localizedDescription)
        }
        
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
    
    func getCartItemsCount() -> Int {
        return cartItems.count
    }
    
    func getCartItem(at index: Int) -> CartItem {
        return cartItems[index]
    }
}
