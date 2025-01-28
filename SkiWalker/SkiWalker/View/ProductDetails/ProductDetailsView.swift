//
//  ProductDetailsView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 18.01.25.
//

import SwiftUI

struct ProductDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var productViewModel = ProductDetailsViewModel()
    @State private var showToast = false
    let productId: String
    @State private var quantity: Int = 1
    
    var body: some View {
        VStack {
            productDetailsHeader
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    productImageCarousel
                    productDetails
                    productQuantity
                    productActionButtons
                    productDescription
                }
            }
        }
        .padding(.horizontal)
        .background(Color.customBackground)
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            Task {
                await productViewModel.fetchProduct(with: productId)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toast(isPresented: $showToast, message: "Added to cart successfully!", type: .success)
    }
    
    @ViewBuilder
    private var productDetailsHeader: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward")
                    .imageScale(.large)
                    .foregroundColor(.primary)
            }
            Spacer()
            Button(action: {
                handleFavorites()
            }) {
                Image(systemName: productViewModel.product?.favorite ?? false ?  "heart.fill" : "heart")
                    .resizable()
                    .foregroundStyle(Color.customGrey)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
        }
    }
    
    @ViewBuilder
    private var productImageCarousel: some View {
        TabView {
            ForEach(productViewModel.product?.photos ?? [], id: \.self.id) { photo in
                AsyncImage(url: URL(string: photo.url)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .frame(height: 270)
        .tabViewStyle(.page)
        
    }
    
    private var productDetails: some View {
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
                Text(CurrencyFormatter.formatPriceToGEL(productViewModel.product?.finalPrice ?? 0))
                    .font(.system(size: 20, weight: .bold))
                Text("Best Price Guarantee")
                    .font(.system(size: 12, weight: .regular))
            }
        }
    }
    
    private var productQuantity: some View {
        HStack {
            Text("Quantity")
                .font(.system(size: 14, weight: .medium))
            Spacer()
            ReusableStepperView(stock: productViewModel.product?.stock ?? 0, quantity: $quantity)
        }
    }
    
    private var productActionButtons: some View {
        VStack(spacing: 15) {
            NavigationLink(destination: CheckoutView(productId: productId, quantity: quantity).navigationBarBackButtonHidden(), label: {
                Text("Buy Now")
                    .buttonModifier()
            })
            
            Button(action: {
                Task {
                    try await productViewModel.addProductToCart(productId: productId, count: quantity)
                    showToast = true
                }
            }) {
                HStack {
                    Image("cart")
                    Text("Add to Cart")
                }
                .buttonModifier()
            }
        }
    }
    
    private var productDescription: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Product Description:")
                .font(.system(size: 18, weight: .semibold))
            
            Text(productViewModel.product?.description ?? "")
                .font(.system(size: 14, weight: .regular))
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
        }
    }
    
    private func handleFavorites() {
        Task {
            if productViewModel.product?.favorite ?? false {
                await productViewModel.deleteFromFavorites(with: productId)
            } else {
                await productViewModel.addToFavorites(with: productId)
            }
            await productViewModel.fetchProduct(with: productId)
        }
    }
}

#Preview {
    ProductDetailsView(productId: "12")
}
