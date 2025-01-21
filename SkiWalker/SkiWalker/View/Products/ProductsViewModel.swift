//
//  ProductsViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 17.01.25.
//
import SwiftUI

final class ProductsViewModel: ObservableObject {
    private let authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol
    private let cartManager: CartManagerProtocol
    @Published var products: [Product] = []
    @Published var errorMessage: String?
    @Published var isFetchingMore: Bool = false
    
    private var currentPage: Int = 1
    private var isLastPage: Bool = false
    
    init(authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler(), cartManager: CartManagerProtocol = CartManager()) {
        self.authenticatedRequestHandler = authenticatedRequestHandler
        self.cartManager = cartManager
    }
    
    func fetchProducts(queryText: String?, category: String?, subCategory: String?, page: Int = 1, pageSize: Int = 5) async {
        guard !isFetchingMore else { return }
        
        let baseURL = "https://api.gargar.dev:8088/Product"
        
        var urlComponents = URLComponents(string: baseURL)
        var queryItems: [URLQueryItem] = []
        
        queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        queryItems.append(URLQueryItem(name: "pageSize", value: "\(pageSize)"))
        
        if let query = queryText, !query.isEmpty {
            queryItems.append(URLQueryItem(name: "name", value: query))
        }
        
        if let category = category, !category.isEmpty {
            queryItems.append(URLQueryItem(name: "category", value: category))
            
            if let subCategory = subCategory, !subCategory.isEmpty {
                queryItems.append(URLQueryItem(name: "subCategory", value: subCategory))
            }
        }
        
        if !queryItems.isEmpty {
            urlComponents?.queryItems = queryItems
        }
        
        guard let urlString = urlComponents?.url?.absoluteString else {
            await handleError(ProductFetchError.invalidURL)
            return
        }
        
        await MainActor.run { [weak self] in
            self?.isFetchingMore = true
        }
        
        do {
            let response: ProductsResponse? = try await authenticatedRequestHandler.sendRequest(
                urlString: urlString,
                method: .get,
                headers: nil,
                body: nil,
                decoder: JSONDecoder()
            )
            
            guard let response = response else {
                throw ProductFetchError.noData
            }
            
            await MainActor.run { [weak self] in
                if response.collection.isEmpty {
                    self?.isLastPage = true
                } else {
                    if page == 1 {
                        self?.products = response.collection
                    } else {
                        self?.products.append(contentsOf: response.collection)
                    }
                    self?.currentPage = page
                }
            }
        } catch {
            await handleError(ProductFetchError.unknownError(error))
        }
        
        await MainActor.run { [weak self] in
            self?.isFetchingMore = false
        }
    }
    
    func fetchNextPage(queryText: String?, category: String?, subCategory: String?) async {
        guard !isLastPage && !isFetchingMore else { return }
        await fetchProducts(queryText: queryText, category: category, subCategory: subCategory, page: currentPage + 1)
    }
    
    func addToCart(productId: String, count: Int = 1) async throws {
        do {
            try await cartManager.addProductToCart(productId: productId, count: count)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    private func handleError(_ error: ProductFetchError) {
        self.errorMessage = error.localizedDescription
        print("Error fetching products: \(error.localizedDescription)")
    }
}


enum ProductFetchError: Error, LocalizedError {
    case invalidURL
    case serverError(statusCode: Int)
    case noData
    case decodingError
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please try again later."
        case .serverError(let statusCode):
            return "Server returned an error with status code: \(statusCode)."
        case .noData:
            return "No products found."
        case .decodingError:
            return "Failed to process the product data."
        case .unknownError(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}
