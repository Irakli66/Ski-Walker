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
    let searchQuery: String
    let category: String
    let subCategory: String
    
    @State private var isLoading: Bool = true
    
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
                    Text("No products found")
                        .foregroundColor(Color.customGrey)
                        .frame(maxWidth: .infinity)
                    Spacer()
                } else {
                    productsListSection
                }
            }
            .background(Color.customBackground)
            .onAppear {
                Task {
                    await productsViewModel.fetchProducts(queryText: searchQuery, category: category, subCategory: subCategory)
                    isLoading = false
                    
                }
            }
            .navigationBarBackButtonHidden(true)
            .toast(isPresented: $showToast, message: "Added to cart successfully!", type: .success)
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
    
    private var productsListSection: some View {
        List(productsViewModel.products, id: \.self.id) { product in
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
                            
                            Button(action: {
                                Task {
                                    if product.favorite {
                                        await productsViewModel.deleteFromFavorites(with: product.id)
                                    } else {
                                        await productsViewModel.addToFavorites(with: product.id)
                                    }
                                    
                                    await productsViewModel.fetchProducts(queryText: searchQuery, category: category, subCategory: subCategory)
                                    
                                    isLoading = false
                                }
                            }) {
                                Image(systemName: product.favorite ?  "heart.fill" : "heart")
                                    .resizable()
                                    .foregroundStyle(Color.customGrey)
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                addProductToCart(with: product.id)
                            }) {
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
                .onAppear {
                    if product == productsViewModel.products.last {
                        Task {
                            await productsViewModel.fetchNextPage(queryText: searchQuery, category: category, subCategory: subCategory)
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
    }
    
    private func addProductToCart(with id: String) {
        Task {
            do {
                try await productsViewModel.addToCart(productId: id)
                showToast = true
            } catch {
                AlertManager.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
