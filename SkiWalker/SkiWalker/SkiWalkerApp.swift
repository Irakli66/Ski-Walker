//
//  SkiWalkerApp.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 09.01.25.
//

import SwiftUI

@main
struct SkiWalkerApp: App {
    @StateObject private var sessionManager = SessionManager()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoggedIn {
                    TabBarView()
                } else {
                    LoginView()
                        .background(.customBackground)
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .environment(\.locale, Locale(identifier: selectedLanguage))
            .environmentObject(sessionManager)
        }
    }
}
