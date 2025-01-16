//
//  ProductsView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 16.01.25.
//
import SwiftUI

struct ProductsView: View {
    let searchQuery: String
    @State private var products: [String] = []
    @State private var isLoading: Bool = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading products...")
            } else if products.isEmpty {
                Text("No products found for \"\(searchQuery)\"")
                    .foregroundColor(.gray)
            } else {
                List(products, id: \.self) { product in
                    Text(product)
                }
            }
        }
        .navigationTitle("Results for '\(searchQuery)'")
        .onAppear {
            fetchProducts()
        }
    }
    
    private func fetchProducts() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if searchQuery.isEmpty {
                products = ["ski", "jackets", "boots"]
            } else {
                products = ["ski", "jackets", "boots"].filter {
                    $0.lowercased().contains(searchQuery.lowercased())
                }
            }
            isLoading = false
        }
    }
}
