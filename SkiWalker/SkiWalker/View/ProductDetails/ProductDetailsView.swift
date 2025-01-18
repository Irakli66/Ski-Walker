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
    let productId: String
    
    var body: some View {
        VStack {
            productDetailsHeader
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            Task {
               try await productViewModel.fetchProduct(with: productId)
            }
        }
    }
    
    private var productDetailsHeader: some View {
        ZStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .imageScale(.large)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            
            Text(productViewModel.product?.name ?? "")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.customBlack)
        }
    }
}

#Preview {
    ProductDetailsView(productId: "12")
}
