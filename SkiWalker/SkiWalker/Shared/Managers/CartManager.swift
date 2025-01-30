//
//  CartManager.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 18.01.25.
//
import SwiftUI

protocol CartManagerProtocol {
    func fetchCartItems() async throws -> [CartItem]
    func addProductToCart(productId: String, count: Int) async throws
    func deleteProductFromCart(productId: String) async throws
}

final class CartManager: CartManagerProtocol {
    private let authenticatedRequestHanlder: AuthenticatedRequestHandlerProtocol
    @AppStorage("cartCount") private var cartCount: Int = 0
    
    init(authenticatedRequestHanlder: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler()) {
        self.authenticatedRequestHanlder = authenticatedRequestHanlder
    }
    
    func fetchCartItems() async throws -> [CartItem] {
        let url = "https://api.gargar.dev:8088/Cart"
        
        let response: Cart? = try await authenticatedRequestHanlder.sendRequest(urlString: url, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
        
        guard let response else {
            return []
        }
        
        cartCount = response.productInCarts.count
        return response.productInCarts
    }
    
    func addProductToCart(productId: String, count: Int) async throws {
        let url = "https://api.gargar.dev:8088/Cart/\(productId)?count=\(count)"

        let _: CartItem? = try await authenticatedRequestHanlder.sendRequest(urlString: url, method: .post, headers: nil, body: nil, decoder: JSONDecoder())
        
        cartCount = try await fetchCartItems().count
        
    }
    
    func deleteProductFromCart(productId: String) async throws {
        let url = "https://api.gargar.dev:8088/Cart/\(productId)"
                
        let _: Cart? = try await authenticatedRequestHanlder.sendRequest(urlString: url, method: .delete, headers: nil, body: nil, decoder: JSONDecoder())
        
        cartCount = try await fetchCartItems().count
    }
}
