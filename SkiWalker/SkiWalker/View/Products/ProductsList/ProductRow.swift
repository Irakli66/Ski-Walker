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
            HStack(alignment: .top, spacing: 10) {
                ReusableAsyncImageView(url: product.photos[0].url)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.customBlack)
                    
                    Text(CurrencyFormatter.formatPriceToGEL(product.price))
                        .font(.subheadline)
                        .foregroundColor(Color.customGrey)
                }
                .frame(maxWidth: .infinity)
                VStack (alignment: .trailing) {
                    Button(action: toggleFavorite) {
                        Image(systemName: product.favorite ? "heart.fill" : "heart")
                            .resizable()
                            .foregroundStyle(Color.customGrey)
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Button(action: addToCart) {
                        HStack(spacing: 5) {
                            Image("cart")
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text("Add")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(Color.customPurple)
                        .foregroundColor(Color.customWhite)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.trailing, 10)
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
