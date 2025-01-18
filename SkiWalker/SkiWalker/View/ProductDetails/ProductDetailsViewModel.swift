//
//  ProductDetailsViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 18.01.25.
//
import SwiftUI

final class ProductDetailsViewModel: ObservableObject {
    private let authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol
    @Published var product: Product?
    
    init(authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler()) {
        self.authenticatedRequestHandler = authenticatedRequestHandler
    }
    
    func fetchProduct(with id: String) async throws {
        let url = "https://api.gargar.dev:8088/Product/\(id)"
        
        let response: Product? = try await authenticatedRequestHandler.sendRequest(urlString: url, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
        
        await MainActor.run {
            product = response
        }
    }
}
