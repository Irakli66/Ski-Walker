//
//  ProfileSettingsView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 11.01.25.
//
import SwiftUI
import PhotosUI

struct ProfileSettingsView: View {
    @StateObject private var profileSettingsViewModel = ProfileSettingsViewModel()
    @State private var avatarItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            profileSettingsHeader
            changeAvatarSection
            changeUserDataSection
            Spacer()
        }
        .padding()
        .background(Color.customBackground)
        .onAppear {
            Task {
                try await profileSettingsViewModel.getCurrentUser()
            }
        }
    }
    
    private var profileSettingsHeader: some View {
        HStack {
            ReusableBackButton()
            Spacer()
            Text("Settings")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.customPurple)
            Spacer()
        }
    }
    
    @ViewBuilder
    private var changeAvatarSection: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                if let selectedProfileImage = profileSettingsViewModel.selectedProfileImage {
                    Image(uiImage: selectedProfileImage)
                        .profileImageModifier(foregroundColor: .clear)
                } else if let profileImageURL = profileSettingsViewModel.profileImage,
                          let url = URL(string: profileImageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 125, height: 125)
                                .clipShape(Circle())
                        case .success(let image):
                            image
                                .profileImageModifier(foregroundColor: .clear)
                        case .failure:
                            Image(systemName: "person.crop.circle.fill")
                                .profileImageModifier(foregroundColor: .customPurple)
                        @unknown default:
                            Image(systemName: "exclamationmark.triangle.fill")
                                .profileImageModifier(size: 50)
                        }
                    }
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .profileImageModifier(foregroundColor: .customPurple)
                }
                
                PhotosPicker(selection: $avatarItem, matching: .images) {
                    Image(systemName: "camera.circle.fill")
                        .profileImageModifier(size: 40, foregroundColor: .customWhite)
                        .overlay(
                            Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .offset(x: -5, y: -5)
                }
            }
            .padding()
        }
        .onChange(of: avatarItem) { newItem in
            changeAvatar(item: newItem)
        }
    }
    
    private var changeUserDataSection: some View {
        VStack(spacing: 20) {
            LabeledTextFieldView(label: "First name", placeholder: "", text: $profileSettingsViewModel.firstname)
            LabeledTextFieldView(label: "Last name", placeholder: "", text: $profileSettingsViewModel.lastname)
            
            Button(action: {
                Task {
                    profileSettingsViewModel.updateProfile()
                }
            }) {
                Text("Update profile")
                    .buttonModifier()
            }
        }
    }
    
    private func changeAvatar(item: PhotosPickerItem?) {
        if let item = item {
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    profileSettingsViewModel.selectedProfileImage = uiImage
                    await profileSettingsViewModel.updateProfileImage()
                } else {
                    print("Failed to load image.")
                }
            }
        }
    }
}


#Preview {
    ProfileSettingsView()
}
