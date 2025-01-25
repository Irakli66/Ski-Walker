//
//  BrowsingHistoryView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 25.01.25.
//

import SwiftUI

struct BrowsingHistoryView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Last seen")
                .font(.system(size: 20, weight: .semibold))
            
            historyList
        }
    }
    
    private var historyList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(homeViewModel.browsingHistory, id: \.id) { product in
                    historyListItem(for: product)
                }
            }
        }
    }
    
    private func historyListItem(for product: BrowsingHistoryItem) -> some View {
        NavigationLink(destination: ProductDetailsView(productId: product.id)) {
            VStack {
                ReusableAsyncImageView(url: product.imageURL)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(product.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.customBlack)
                    Text(product.finalPrice.formatted(.currency(code: "GEL")))
                        .foregroundColor(.primary)
                        .font(.subheadline)
                }
            }
            .frame(minWidth: 150, maxHeight: 200)
            .padding(10)
            .background(Color.customWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 2)
        }
    }
}

#Preview {
    BrowsingHistoryView()
        .environmentObject(HomeViewModel())
}
