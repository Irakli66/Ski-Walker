//
//  TabBarView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Tab = .home
    
    private let tabs: [(icon: String, activeIcon: String, tab: Tab)] = [
        ("home",      "homeActive",      .home),
        ("favorites", "favoritesActive", .favorites),
        ("cart",      "cartActive",      .cart),
        ("profile",   "profileActive",   .profile),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            TabContentView(selectedTab: selectedTab)
            
            HStack {
                ForEach(tabs, id: \.tab) { item in
                    Spacer()
                    VStack {
                        Image(selectedTab == item.tab ? item.activeIcon : item.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
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
            .padding(.bottom, 15)
            .background(Color.customWhite)
        }
    }
}

struct TabContentView: View {
    let selectedTab: Tab
    
    var body: some View {
        switch selectedTab {
        case .home:
            NavigationView {
                HomeView()
            }
        case .favorites:
            NavigationView {
                FavoritesView()
            }
        case .cart:
            NavigationView {
                CartView()
            }
        case .profile:
            NavigationView {
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
