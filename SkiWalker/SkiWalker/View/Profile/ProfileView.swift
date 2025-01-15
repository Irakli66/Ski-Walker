//
//  ProfileView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import SwiftUI

struct ProfileView: View {
    @StateObject private var profileViewModel = ProfileViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var showToast = false
    
    private let tabs: [ProfileTabItem] = [
        ProfileTabItem(icon: "list.bullet.rectangle.portrait", title: "Order History", destination: AnyView(OrderHistoryView().background(.customBackground))),
        ProfileTabItem(icon: "creditcard.fill", title: "Payment Methods", destination: AnyView(PaymentMethodsView())),
        ProfileTabItem(icon: "mappin.circle", title: "Addresses", destination: AnyView(AddressesView())),
        ProfileTabItem(icon: "gearshape.fill", title: "Settings", destination: AnyView(ProfileSettingsView()))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    profileHeader
                    balanceSection
                    languageToggle
                    themeToggle
                    tabNavigationList
                    
                    Button(action: {
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showToast = false
                            sessionManager.logout()
                        }
                    }) {
                        Text("Log out")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
                .padding(20)
            }
            .background(Color.customBackground)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toast(isPresented: $showToast, message: "Logged Out Successfully!", type: .success)
        }
    }
    
    private var profileHeader: some View {
        HStack(spacing: 15) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundStyle(.customPurple)
                .shadow(radius: 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(profileViewModel.user?.firstname ?? "") \(profileViewModel.user?.lastname ?? "")")
                    .font(.system(size: 22, weight: .bold))
                Text(profileViewModel.user?.email ?? "")
                    .font(.system(size: 14))
                    .foregroundStyle(.customGrey)
            }
            Spacer()
        }
        .onAppear() {
            Task {
                do {
                    try await profileViewModel.getCurrentUser()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private var balanceSection: some View {
        HStack {
            Text("Balance:")
                .font(.system(size: 16, weight: .semibold))
            Text("0 ₾")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.green)
            
            Spacer()
            Button(action: {
                print("add funds")
            }) {
                Text("+ Add Funds")
                    .font(.system(size: 14, weight: .medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.customBlue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color.customWhite)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 3)
    }
    
    private var languageToggle: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Language")
                .font(.system(size: 16, weight: .semibold))
            Picker("Language", selection: $selectedLanguage) {
                Text("English").tag("en")
                Text("ქართული").tag("ka")
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
        .background(Color.customWhite)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 3)
    }
    
    private var themeToggle: some View {
        HStack {
            Text("Dark Mode")
                .font(.system(size: 16, weight: .semibold))
            Spacer()
            Toggle(isOn: $isDarkMode) {
                EmptyView()
            }
            .toggleStyle(SwitchToggleStyle(tint: .customBlue))
        }
        .padding()
        .background(Color.customWhite)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 3)
    }
    
    private var tabNavigationList: some View {
        VStack(spacing: 1) {
            ForEach(tabs) { tab in
                NavigationLink(destination: tab.destination .navigationBarHidden(true)) {
                    HStack {
                        Image(systemName: tab.icon)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.customPurple)
                        Text(LocalizedStringKey(tab.title))
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.customWhite)
                }
                .buttonStyle(PlainButtonStyle())
                Divider()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 2)
    }
}

#Preview {
    ProfileView()
}

struct ProfileTabItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let destination: AnyView
}
