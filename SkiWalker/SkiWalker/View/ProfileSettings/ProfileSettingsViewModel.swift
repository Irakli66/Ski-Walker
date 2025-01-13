//
//  ProfileSettingsViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 13.01.25.
//
import SwiftUI

final class ProfileSettingsViewModel: ObservableObject {
    @Published var profileImage: Image?
    @Published var email: String = ""
    
    func updateProfile() {
        print(profileImage ?? "", email)
    }
}
