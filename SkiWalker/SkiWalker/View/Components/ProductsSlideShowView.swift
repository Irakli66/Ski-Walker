//
//  ProductsSlideShowView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 16.01.25.
//
import SwiftUI

struct ProductsSlideShowView: View {
    let title: String
    let products: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text(LocalizedStringKey(title))
                .font(.system(size: 20, weight: .semibold))
            ScrollView (.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(products, id: \.self) { product in
                        VStack {
                            Image(systemName: product)
                                .resizable()
                                .frame(width: 75, height: 75)
                            VStack(alignment: .leading, spacing: 10) {
                                Text("product name")
                                Text("130 ₾")
                            }
                        }
                        .padding(10)
                        .background(.customWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 2)
                    }
                }
                .padding(.vertical, 10)
            }
        }
    }
}
