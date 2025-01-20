//
//  CartViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 20.01.25.
//
import Foundation

final class CartViewModel {
    private let cartManager: CartManagerProtocol
    private var cartItems: [CartItem] = [CartItem(id: "312312", count: 5, product: Product(id: "b4250b33-9f40-403c-995d-20136c333121", name: "Test Product", description: "test", price: 12, stock: 20, discount: 0, finalPrice: 12, rentable: false, rentalPrice: 0, rentalStock: 0, category: "clothing", subcategory: "jacket", vendorId: "31232131", photos: [Photo(id: "1231", name: "test", url: "https://api.gargar.dev:8088/Products/b4250b33-9f40-403c-995d-20136c333121/1.png")]))]
    
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
