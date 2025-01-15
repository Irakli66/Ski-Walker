//
//  ProfileViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 15.01.25.
//
import SwiftUI

final class ProfileViewModel: ObservableObject {
    private let authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol
    @Published var user: User?
    
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
        
        DispatchQueue.main.async { [weak self] in
            self?.user = currentUser
        }
    }
}
