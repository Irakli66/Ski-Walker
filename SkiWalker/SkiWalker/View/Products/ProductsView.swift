//
//  ProductsView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 16.01.25.
//
import SwiftUI

struct ProductsView: View {
    @Environment(\.presentationMode) var presentationMode
    let searchQuery: String
    @State private var products: [String] = []
    @State private var isLoading: Bool = true
    
    var body: some View {
        VStack {
            productsViewHeader
            if isLoading {
                Spacer()
                ProgressView("Loading products...")
                    .frame(maxWidth: .infinity)
                Spacer()
            } else if products.isEmpty {
                Spacer()
                Text("No products found for \"\(searchQuery)\"")
                    .foregroundColor(Color.customGrey)
                    .frame(maxWidth: .infinity)
                Spacer()
            } else {
                productsListSection
            }
        }
        .background(Color.customBackground)
        .onAppear {
            fetchProducts()
        }
        .navigationBarBackButtonHidden(true)
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
            
            Text(searchQuery)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.customBlack)
        }
        .padding()
    }
    
    private var productsListSection: some View {
        List(products, id: \.self) { product in
            HStack(alignment: .top, spacing: 15) {
                Image(systemName: "photo.stack.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                    .padding(.vertical, 5)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(product)
                        .font(.headline)
                        .foregroundColor(Color.customBlack)
                    
                    Text("130 ₾")
                        .font(.subheadline)
                        .foregroundColor(Color.customGrey)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            print("Add to favorites")
                        }) {
                            Image("favorites")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            print("Add to cart func")
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
                Spacer()
            }
            .background(Color.clear)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            .contentShape(Rectangle())
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
    }


    
    private func fetchProducts() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if searchQuery.isEmpty {
                products = ["ski", "jackets", "boots"]
            } else {
                products = ["ski", "jackets", "boots"].filter {
                    $0.lowercased().contains(searchQuery.lowercased())
                }
            }
            isLoading = false
        }
    }
}
