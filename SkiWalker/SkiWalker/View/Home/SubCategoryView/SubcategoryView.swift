//
//  SubcategoryView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 16.01.25.
//
import SwiftUI

struct SubcategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    let category: ProductCategory
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 25) {
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
                    
                    Text(LocalizedStringKey(category.rawValue))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.customBlack)
                }
                
                NavigationLink {
                    ProductsView(searchQuery: "", category: category.rawValue, subCategory: "")
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
    }
    
    private var categoriesSection: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                ForEach(category.subcategories, id: \.self) { subcategory in
                    NavigationLink {
                        ProductsView(searchQuery: "", category: category.rawValue, subCategory: subcategory.rawValue)
                    } label: {
                        HStack {
                            HStack {
                                Image(subcategory.iconName)
                                    .padding(10)
                                    .background(Color.customWhite)
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                Text(LocalizedStringKey(subcategory.rawValue))
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
