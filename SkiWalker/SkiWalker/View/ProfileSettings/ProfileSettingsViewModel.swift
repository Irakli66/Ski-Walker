//
//  ProfileSettingsViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 13.01.25.
//
import SwiftUI

final class ProfileSettingsViewModel: ObservableObject {
    private let authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol
    @Published var user: User?
    @Published var selectedProfileImage: UIImage?
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var profileImage: String?
    
    init(authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler()) {
        self.authenticatedRequestHandler = authenticatedRequestHandler
        
        Task {
            do {
                try await self.getCurrentUser()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getCurrentUser() async throws {
        let urlString = "https://api.gargar.dev:8088/User/current"
        let response: User? = try await authenticatedRequestHandler.sendRequest(urlString: urlString, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
        
        guard let currentUser = response else {
            fatalError("Could not fetch current user")
        }
        
        await MainActor.run { [weak self] in
            self?.user = currentUser
            self?.firstname = currentUser.firstname ?? ""
            self?.lastname = currentUser.lastname ?? ""
        }
    }
    
    func updateProfileImage() async {
        guard let selectedProfileImage = selectedProfileImage else {
            print("No profile image available to upload.")
            return
        }
        
        guard let imageData = selectedProfileImage.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data.")
            return
        }
        
        print(imageData)
    }
    
    func updateProfile() {
        
        print(firstname, "\n", lastname)
    }
}
