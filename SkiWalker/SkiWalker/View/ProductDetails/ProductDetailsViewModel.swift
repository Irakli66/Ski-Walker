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
    @Published var product: Product?
    
    init(authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler(), cartManager: CartManagerProtocol = CartManager()) {
        self.authenticatedRequestHandler = authenticatedRequestHandler
        self.cartManager = cartManager
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
}
