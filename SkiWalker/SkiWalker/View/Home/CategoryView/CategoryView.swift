//
//  CategoryView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 16.01.25.
//

import SwiftUI

struct CategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    private let categories: [ProductCategory] = [.snowboard, .ski, .clothing]
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading, spacing: 25) {
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
                    
                    Text("Categories")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.customBlue)
                }
                
                NavigationLink {
                    ProductsView(searchQuery: "")
                } label: {
                    Text("See All")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.customBlue)
                }
                
                LazyVStack(spacing: 30) {
                    ForEach(categories, id: \.self) { category in
                        NavigationLink {
                            if category.subcategories.isEmpty {
                                ProductsView(searchQuery: category.rawValue)
                            } else {
                                SubcategoryView(category: category)
                            }
                        } label: {
                            HStack {
                                HStack {
                                    Image(category.iconName)
                                        .padding(10)
                                        .background(Color.customWhite)
                                        .clipShape(RoundedRectangle(cornerRadius: 50))
                                    Text(category.rawValue)
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundStyle(Color.customBlue)
                                }
                                
                                Spacer()
                                Image(systemName: "chevron.forward")
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color.customBackground)
            .navigationBarBackButtonHidden(true)
        }
    }
}


#Preview {
    CategoryView()
}
