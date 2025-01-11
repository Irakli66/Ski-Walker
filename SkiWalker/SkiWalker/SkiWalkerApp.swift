//
//  SkiWalkerApp.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 09.01.25.
//

import SwiftUI

@main
struct SkiWalkerApp: App {
    @State private var isLoggedIn: Bool = true
    @State private var currentLocale = Locale(identifier: "en")
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                TabBarView()
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            } else {
                LoginView()
                    .background(.customBackground)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            }
        }
    }
}
