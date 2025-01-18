//
//  ProductsSlideShowView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 16.01.25.
//
import SwiftUI

struct ProductsSlideShowView: View {
    let title: String
    let products: [Product]
    let isSale: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(LocalizedStringKey(title))
                .font(.system(size: 20, weight: .semibold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 5) {
                    ForEach(products, id: \.id) { product in
                        productCard(for: product)
                    }
                }
                .padding(.vertical, 10)
            }
        }
    }

    @ViewBuilder
    private func productCard(for product: Product) -> some View {
        VStack {
            ReusableAsyncImageView(url: product.photos.first?.url ?? "")
            
            VStack(alignment: .leading, spacing: 10) {
                Text(product.name)
                    .font(.system(size: 16, weight: .semibold))
                
                if isSale {
                    salePriceView(for: product)
                } else {
                    regularPriceView(for: product)
                }
            }
        }
        .frame(minWidth: 150, maxHeight: 200)
        .padding(10)
        .background(Color.customWhite)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 2)
    }

    @ViewBuilder
    private func salePriceView(for product: Product) -> some View {
        HStack {
            Text(product.finalPrice.formatted(.currency(code: "GEL")))
                .foregroundColor(Color.customBlack)
                .fontWeight(.bold)
                .font(.system(size: 14))
            
            Text(product.price.formatted(.currency(code: "GEL")))
                .strikethrough()
                .foregroundColor(Color.customGrey)
                .font(.system(size: 12))
            
            Text("\(String(format: "%.0f", product.discount ?? 0))%")
                .font(.system(size: 12))
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .background(Color.red)
                .foregroundColor(Color.white)
                .cornerRadius(5)
        }
        .font(.subheadline)
    }

    @ViewBuilder
    private func regularPriceView(for product: Product) -> some View {
        Text(product.price.formatted(.currency(code: "GEL")))
            .foregroundColor(.primary)
            .font(.subheadline)
    }
}
