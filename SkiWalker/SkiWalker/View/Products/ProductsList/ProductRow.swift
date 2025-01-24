//
//  ProductRow.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 24.01.25.
//

import SwiftUI

struct ProductRow: View {
    @EnvironmentObject var productsViewModel: ProductsViewModel
    let product: Product

    var body: some View {
        NavigationLink(destination: ProductDetailsView(productId: product.id)) {
            HStack(alignment: .top, spacing: 15) {
                ReusableAsyncImageView(url: product.photos[0].url)

                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name)
                        .font(.headline)
                        .foregroundColor(Color.customBlack)

                    Text("\(product.price.formatted(.currency(code: "GEL")))")
                        .font(.subheadline)
                        .foregroundColor(Color.customGrey)

                    HStack {
                        Spacer()

                        Button(action: toggleFavorite) {
                            Image(systemName: product.favorite ? "heart.fill" : "heart")
                                .resizable()
                                .foregroundStyle(Color.customGrey)
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Button(action: addToCart) {
                            HStack(spacing: 5) {
                                Image("cart")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                Text("Add")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(Color.customPurple)
                            .foregroundColor(Color.customWhite)
                            .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .background(Color.clear)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            .contentShape(Rectangle())
            .padding(.horizontal)
        }
    }

    private func addToCart() {
        Task {
            do {
                try await productsViewModel.addToCart(productId: product.id)
            } catch {
                AlertManager.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }

    private func toggleFavorite() {
        Task {
            if product.favorite {
                await productsViewModel.deleteFromFavorites(with: product.id)
            } else {
                await productsViewModel.addToFavorites(with: product.id)
            }
        }
    }
}
