//
//  ProductsList.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 24.01.25.
//

import SwiftUI

struct ProductsList: View {
    @EnvironmentObject var productsViewModel: ProductsViewModel
    let searchQuery: String
    let category: String
    let subCategory: String
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 15) {
                ForEach(productsViewModel.products, id: \.id) { product in
                    ProductRow(product: product)
                        .onAppear {
                            fetchNextPage(for: product)
                        }
                }
            }
            .padding(.top, 10)
            .background(Color.clear)
        }
    }
    
    private func fetchNextPage(for product: Product) {
        if product == productsViewModel.products.last &&
            !productsViewModel.isFetchingMore &&
            !productsViewModel.isLastPage {
            Task {
                await productsViewModel.fetchNextPage(
                    queryText: searchQuery,
                    category: category,
                    subCategory: subCategory
                )
            }
        }
    }
}
