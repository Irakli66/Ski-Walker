//
//  HomeViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 18.01.25.
//
import SwiftUI

final class HomeViewModel: ObservableObject {
    private let authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol
    private let browsingHistoryManager: BrowsingHistoryManagerProtocol
    
    @Published var popularProducts: [Product] = []
    @Published var saleProducts: [Product] = []
    @Published var browsingHistory: [BrowsingHistoryItem] = []
    @Published var isLoading: Bool = false
    
    init(authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler(), browsingHistoryManager: BrowsingHistoryManagerProtocol = BrowsingHistoryManager()) {
        self.authenticatedRequestHandler = authenticatedRequestHandler
        self.browsingHistoryManager = browsingHistoryManager
        
        reloadBrowsingHistory()
    }
    
    func fetchPopularProducts() async throws {
        try await fetchProducts(from: APIEndpoints.Product.popular) { [weak self] products in
            self?.popularProducts = products
        }
    }
    
    func fetchSaleProducts() async throws {
        try await fetchProducts(from: APIEndpoints.Product.onSale) { [weak self] products in
            self?.saleProducts = products
        }
    }
    
    private func fetchProducts(from urlString: String, update: @escaping ([Product]) -> Void) async throws {
        await MainActor.run {
            isLoading = true
        }
        
        do {
            let response: ProductsResponse? = try await authenticatedRequestHandler.sendRequest(
                urlString: urlString,
                method: .get,
                headers: nil,
                body: nil,
                decoder: JSONDecoder()
            )
            
            guard let products = response?.collection else {
                throw ProductFetchError.noData
            }
            
            await MainActor.run {
                update(products)
                isLoading = false
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func reloadBrowsingHistory() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.browsingHistory = self.browsingHistoryManager.getBrowsingHistory()
        }
    }
}
