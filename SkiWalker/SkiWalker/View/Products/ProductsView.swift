//
//  ProductsView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 16.01.25.
//
import SwiftUI

struct ProductsView: View {
    @StateObject private var productsViewModel = ProductsViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var showToast = false
    @State private var isInitialFetchDone = false
    @State private var isLoading: Bool = true
    let searchQuery: String
    let category: String
    let subCategory: String
    
    var body: some View {
        NavigationStack {
            VStack {
                productsViewHeader
                if isLoading {
                    Spacer()
                    ProgressView("Loading products...")
                        .frame(maxWidth: .infinity)
                    Spacer()
                } else if productsViewModel.products.isEmpty {
                    Spacer()
                    Image("noResult")
                        .resizable()
                        .frame(width: 200, height: 230)
                    Spacer()
                } else {
                    ProductsList(searchQuery: searchQuery, category: category, subCategory: subCategory)
                }
            }
            .background(Color.customBackground)
            .onAppear {
                fetchInitialProducts()
            }
            .navigationBarBackButtonHidden(true)
            .toast(isPresented: $productsViewModel.showToast, message: "Added to cart successfully!", type: .success)
            .environmentObject(productsViewModel)
        }
    }
    
    private var productsViewHeader: some View {
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
            
            if !searchQuery.isEmpty {
                Text(searchQuery)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.customBlack)
            } else if searchQuery.isEmpty, subCategory.isEmpty, category.isEmpty {
                Text("Everything")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.customBlack)
            } else if subCategory.isEmpty {
                Text(category)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.customBlack)
            } else {
                Text(subCategory)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.customBlack)
            }
        }
        .padding()
    }
    
    private func fetchInitialProducts() {
        if !isInitialFetchDone {
            Task {
                await productsViewModel.fetchProducts(queryText: searchQuery, category: category, subCategory: subCategory)
                isLoading = false
                isInitialFetchDone = true
            }
        }
    }
}
