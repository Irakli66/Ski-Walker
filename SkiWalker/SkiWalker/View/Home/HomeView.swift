//
//  ContentView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 09.01.25.
//
import SwiftUI

import SwiftUI

struct HomeView: View {
    @State private var searchText: String = ""
    @State private var navigateToProducts: Bool = false
    @State private var searchHistory: [String] = []
    private var products = ["person", "photo.stack.fill", "simcard.fill"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                customSearchBar
                
                ScrollView() {
                    ProductsSlideShowView(title: "Popular products", products: products)
                }
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $navigateToProducts) {
                ProductsView(searchQuery: searchText, category: "", subCategory: "")
            }
            .background(Color.customBackground)
        }
    }
    
    private var customSearchBar: some View {
        HStack {
            NavigationLink(destination: CategoryView()) {
                Image(systemName: "slider.horizontal.3")
                    .imageScale(.large)
                    .foregroundColor(Color.customWhite)
                    .padding(10)
                    .background(Color.customPurple)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.customWhite)
                    .frame(maxWidth: .infinity, maxHeight: 43)
                Image("searchBarBackground")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 43)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                TextField("Search skis, boards, gear...", text: $searchText, onCommit: {
                    if !searchText.isEmpty {
                        searchHistory.append(searchText)
                        navigateToProducts = true
                    }
                })
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .background(.clear)
                .cornerRadius(10)
                .submitLabel(.search)
            }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
    }
}



#Preview {
    HomeView()
}



