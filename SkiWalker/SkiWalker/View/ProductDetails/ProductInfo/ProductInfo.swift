//
//  ProductInfo.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 31.01.25.
//

import SwiftUI

struct ProductInfo: View {
    @EnvironmentObject private var productViewModel: ProductDetailsViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text(productViewModel.product?.name ?? "")
                .font(.system(size: 16, weight: .bold))
            
            HStack(spacing: 5) {
                Text("Seller:")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.customGrey)
                Text(productViewModel.vendor?.companyName ?? "")
                    .foregroundStyle(Color.customPurple)
                    .font(.system(size: 14, weight: .medium))
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                if productViewModel.product?.discount ?? 0 > 0 {
                    HStack {
                        Text(CurrencyFormatter.formatPriceToGEL(productViewModel.product?.finalPrice ?? 0))
                            .foregroundColor(Color.customBlack)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                        
                        Text(CurrencyFormatter.formatPriceToGEL(productViewModel.product?.price ?? 0))
                            .strikethrough()
                            .foregroundColor(Color.customGrey)
                            .font(.system(size: 14))
                        
                        Text("\(String(format: "%.0f", productViewModel.product?.discount ?? 0))%")
                            .font(.system(size: 14))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 3)
                            .background(Color.red)
                            .foregroundColor(Color.white)
                            .cornerRadius(5)
                    }
                    .font(.subheadline)
                } else {
                    Text(CurrencyFormatter.formatPriceToGEL(productViewModel.product?.finalPrice ?? 0))
                        .font(.system(size: 20, weight: .bold))
                }
                
                Text("Best Price Guarantee")
                    .font(.system(size: 12, weight: .regular))
            }
        }
    }
}

#Preview {
    ProductInfo()
}
