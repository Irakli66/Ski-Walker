//
//  PromotionCarouselView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 26.01.25.
//

import SwiftUI

struct PromotionCarouselView: View {
    private let promos: [(image: String, category: ProductCategory)] = [
        (AppImages.skiPromo.rawValue, .ski),
        (AppImages.snowboardPromo.rawValue, .snowboard),
        (AppImages.clothingPromo.rawValue, .clothing)
    ]
    
    var body: some View {
        TabView {
            ForEach(promos, id: \.image) { promo in
                GeometryReader { geo in
                    NavigationLink(destination: ProductsView(searchQuery: "", category: promo.category.rawValue, subCategory: "")) {
                        Image(promo.image)
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
        .tabViewStyle(.page)
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    PromotionCarouselView()
}
