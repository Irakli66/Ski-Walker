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
                    .foregroundColor(.customBlack)
            }
            
            NavigationLink {
                ProductsView(searchQuery: "", category: "", subCategory: "")
            } label: {
                Text("See All")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.customBlack)
            }
            
            categoriesSection
            
        }
        .padding()
        .background(Color.customBackground)
        .navigationBarBackButtonHidden(true)
    }
    
    private var categoriesSection: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                ForEach(categories, id: \.self) { category in
                    NavigationLink {
                        if category.subcategories.isEmpty {
                            ProductsView(searchQuery: "", category: category.rawValue, subCategory: "")
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
                                Text(LocalizedStringKey(category.rawValue))
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(Color.customBlack)
                            }
                            
                            Spacer()
                            Image(systemName: "chevron.forward")
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    CategoryView()
}
