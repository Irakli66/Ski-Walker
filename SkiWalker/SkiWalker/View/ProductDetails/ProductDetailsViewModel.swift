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
    private let browsingHistoryManager: BrowsingHistoryManagerProtocol
    @Published var product: Product?
    @Published var vendor: User?
    
    init(authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler(), cartManager: CartManagerProtocol = CartManager(), favoritesManager: FavoritesManagerProtocol = FAvoritesManager(), browsingHistoryManager: BrowsingHistoryManagerProtocol = BrowsingHistoryManager()) {
        self.authenticatedRequestHandler = authenticatedRequestHandler
        self.cartManager = cartManager
        self.favoritesManager = favoritesManager
        self.browsingHistoryManager = browsingHistoryManager
    }
    
    func fetchProduct(with id: String) async {
        let url = APIEndpoints.Product.details(for: id)
        
        do {
            let response: Product? = try await authenticatedRequestHandler.sendRequest(urlString: url, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
            
            await MainActor.run { [weak self] in
                self?.product = response
                self?.addToBrowsingHistory(with: self?.product)
            }
            
            guard let product else { return }
            await fetchVendor(with: product.vendorId)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchVendor(with id: String) async {
        let url = APIEndpoints.User.details(for: id)
        
        do {
            let response: User? = try await authenticatedRequestHandler.sendRequest(urlString: url, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
            await MainActor.run { [weak self] in
                self?.vendor = response
            }
        } catch {
            print(error.localizedDescription)
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
    
    func addToBrowsingHistory(with product: Product?) {
        guard let product = product else { return }
        browsingHistoryManager.addToBrowsingHistory(id: product.id, imageURL: product.photos[0].url, name: product.name, finalPrice: product.price)
    }
}
