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
    
    private enum Endpoint: String {
        case popular = "https://api.gargar.dev:8088/Product/popilar"
        case onSale = "https://api.gargar.dev:8088/Product/onSale"
    }
    
    init(authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler(), browsingHistoryManager: BrowsingHistoryManagerProtocol = BrowsingHistoryManager()) {
        self.authenticatedRequestHandler = authenticatedRequestHandler
        self.browsingHistoryManager = browsingHistoryManager
        
        reloadBrowsingHistory()
    }
    
    func fetchPopularProducts() async throws {
        try await fetchProducts(from: .popular) { [weak self] products in
            self?.popularProducts = products
        }
    }
    
    func fetchSaleProducts() async throws {
        try await fetchProducts(from: .onSale) { [weak self] products in
            self?.saleProducts = products
        }
    }
    
    private func fetchProducts(from endpoint: Endpoint, update: @escaping ([Product]) -> Void) async throws {
        let response: ProductsResponse? = try await authenticatedRequestHandler.sendRequest(
            urlString: endpoint.rawValue,
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
        }
    }
    
    func reloadBrowsingHistory() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.browsingHistory = self.browsingHistoryManager.getBrowsingHistory()
        }
    }
}
