//
//  ProfileSettingsViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 13.01.25.
//
import SwiftUI

final class ProfileSettingsViewModel: ObservableObject {
    private let authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol
    @Published var selectedProfileImage: UIImage?
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var profileImage: String?
    
    init(authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler()) {
        self.authenticatedRequestHandler = authenticatedRequestHandler
    }
    
    func getCurrentUser() async throws {
        let urlString = APIEndpoints.User.currentUser
        let response: User? = try await authenticatedRequestHandler.sendRequest(urlString: urlString, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
        
        guard let currentUser = response else {
            fatalError("Could not fetch current user")
        }
        await MainActor.run { [weak self] in
            self?.firstname = currentUser.firstname ?? ""
            self?.lastname = currentUser.lastname ?? ""
            self?.profileImage = currentUser.photo?.url ?? ""
        }
    }
    
    func updateProfileImage() async throws {
        let urlString = APIEndpoints.User.updateProfileImage

        guard let selectedProfileImage = selectedProfileImage,
              let imageData = selectedProfileImage.jpegData(compressionQuality: 0.3) else {
            print("No profile image available to upload.")
            return
        }

        let boundary = UUID().uuidString
        let headers: [String: String] = [
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]

        var body = Data()
        
        let filename = "profile.jpg"
        let mimeType = "image/jpeg"

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        let _: User? = try await authenticatedRequestHandler.sendRequest(
            urlString: urlString,
            method: .post,
            headers: headers,
            body: body,
            decoder: JSONDecoder()
        )
    }
    
    func updateProfile() async throws {
        let url = APIEndpoints.User.updateProfile
                
        let requestBody: [String: String] = [
            "firstname": firstname,
            "lastname": lastname,
        ]
        
        let bodyData = try? JSONEncoder().encode(requestBody)
        
        let _: User? = try await authenticatedRequestHandler.sendRequest(urlString: url, method: .post, headers: nil, body: bodyData, decoder: JSONDecoder())
    }
}
