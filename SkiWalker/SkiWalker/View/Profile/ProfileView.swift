//
//  ProfileView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//

import SwiftUI

struct ProfileView: View {
    private let tabs: [(icon: String, name: String, tab: ProfileTabs)] = [
        ("list.bullet.rectangle.portrait", "Order History",  .orderHistory),
        ("creditcard.fill", "Payment Methods", .paymentMethods),
        ("mappin.circle", "Addresses", .addressess),
        ("gearshape.fill", "Settings", .profileSettings),
    ]
    var body: some View {
        NavigationStack {
            VStack (spacing: 30) {
                VStack (spacing: 25) {
                    Text("Profile")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.customPurple)
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.customPurple)
                    VStack {
                        Text("John Doe")
                            .font(.system(size: 20, weight: .regular))
                        Text("ID: 6578")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.customGrey)
                    }
                    ZStack {
                        Text("Balance 0 ₾ +")
                            .font(.system(size: 14, weight: .regular))
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(.customWhite)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                    .shadow(color: .customGrey.opacity(0.2), radius: 4, x: 0, y: 3)
                }
                
                VStack {
                    ForEach(tabs, id: \.self.tab) { tab in
                        NavigationLink(destination: OrderHistoryView()) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: tab.icon)
                                    Text(tab.name)
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .padding(.horizontal, 20)
                                Divider()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                Spacer()
            }
            .background(.customBackground)
        }
    }
}

#Preview {
    ProfileView()
}

enum ProfileTabs {
    case orderHistory
    case paymentMethods
    case addressess
    case profileSettings
}
