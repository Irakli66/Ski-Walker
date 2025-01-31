//
//  ContentView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 09.01.25.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var searchText: String = ""
    @State private var navigateToProducts: Bool = false
    @State private var searchHistory: [String] = []
    
    var body: some View {
        VStack(spacing: 20) {
            customSearchBar
            ScrollView(showsIndicators: false) {
                PromotionCarouselView()
                content
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .padding(.horizontal)
        .navigationDestination(isPresented: $navigateToProducts) {
            ProductsView(searchQuery: searchText, category: "", subCategory: "")
        }
        .background(Color.customBackground)
        .environmentObject(homeViewModel)
        .onAppear() {
            Task {
                try await homeViewModel.fetchPopularProducts()
                try await homeViewModel.fetchSaleProducts()
                homeViewModel.reloadBrowsingHistory()
            }
        }
    }
    
    @ViewBuilder private var content: some View {
        if homeViewModel.isLoading {
            VStack(spacing: 20) {
                SkeletonView()
                    .frame(height: 200)
                
                SkeletonView()
                    .frame(height: 200)
            }
        } else {
            VStack {
                ProductsSlideShowView(title: "Popular products", products: homeViewModel.popularProducts)
                
                ProductsSlideShowView(title: "Sale products", products: homeViewModel.saleProducts)
                
                browsingHistory
            }
            .padding(.top, 20)
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
                    .fill(.white)
                    .frame(maxWidth: .infinity, maxHeight: 43)
                Image("searchBarBackground")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 43)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                if searchText.isEmpty {
                    Text("Search skis, boards, gear...")
                        .foregroundColor(.black)
                        .padding(.leading, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack {
                    TextField("", text: $searchText, onCommit: {
                        if !searchText.isEmpty {
                            searchHistory.append(searchText)
                            navigateToProducts = true
                        }
                    })
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
                    .background(.clear)
                    .foregroundStyle(.black)
                    .cornerRadius(10)
                    .submitLabel(.search)
                    
                    Spacer()
                    
                    Button(action: {
                        navigateToProducts = true
                    }){
                        Image(systemName: "magnifyingglass.circle")
                            .foregroundStyle(.white)
                            .font(.system(size: 24))
                    }
                }
                
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
    
    @ViewBuilder
    private var browsingHistory: some View {
        if !homeViewModel.browsingHistory.isEmpty {
            BrowsingHistoryView()
        }
    }
}

#Preview {
    HomeView()
}
