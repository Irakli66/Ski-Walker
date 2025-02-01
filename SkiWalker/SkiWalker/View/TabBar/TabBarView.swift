//
//  TabBarView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Tab = .home
    @AppStorage("cartCount") private var cartCount: Int = 0
    
    private let tabs: [(icon: String, activeIcon: String, tab: Tab)] = [
        (AppIcons.home.rawValue,      AppIcons.homeActive.rawValue,      .home),
        (AppIcons.favorites.rawValue, AppIcons.favoritesActive.rawValue, .favorites),
        (AppIcons.cart.rawValue,      AppIcons.cartActive.rawValue,      .cart),
        (AppIcons.profile.rawValue,   AppIcons.profileActive.rawValue,   .profile),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            TabContentView(selectedTab: selectedTab)
            
            HStack {
                ForEach(tabs, id: \.tab) { item in
                    Spacer()
                    ZStack {
                        Image(selectedTab == item.tab ? item.activeIcon : item.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        if item.tab == .cart {
                            Text("\(cartCount)")
                                .font(.system(size: 12))
                                .padding(5)
                                .background(.red)
                                .foregroundStyle(.white)
                                .clipShape(Circle())
                                .offset(x: 13, y: -10)
                        }
                    }
                    .padding(15)
                    .background(selectedTab == item.tab ? Color.customBlue : Color.customWhite)
                    .cornerRadius(50)
                    .onTapGesture {
                        selectedTab = item.tab
                    }
                    Spacer()
                }
            }
            .frame(height: 60)
            .padding(.vertical, 10)
            .background(Color.customWhite)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct TabContentView: View {
    let selectedTab: Tab
    
    var body: some View {
        switch selectedTab {
        case .home:
            NavigationStack {
                HomeView()
            }
        case .favorites:
            NavigationStack {
                FavoritesView()
                    .background(Color.customBackground)
            }
        case .cart:
            NavigationStack {
                CartView()
                    .background(Color.customBackground)
            }
        case .profile:
            NavigationStack {
                ProfileView()
            }
        }
    }
}

enum Tab: Hashable {
    case home
    case favorites
    case cart
    case profile
}

#Preview {
    TabBarView()
}
