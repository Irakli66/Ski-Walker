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
    @State private var avatarImage: Image?
    
    var body: some View {
        VStack {
            profileSettingsHeader
            changeAvatarSection
            changeUserDataSection
            Spacer()
        }
        .padding()
        .background(Color.customBackground)
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
    
    private var changeAvatarSection: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                (avatarImage ?? Image(systemName: "person.crop.circle.fill"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 125, height: 125)
                    .foregroundStyle(Color.customPurple)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.gray, lineWidth: 2)
                    )
                    .shadow(radius: 5)
                
                PhotosPicker(selection: $avatarItem, matching: .images) {
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.customWhite)
                        .background(Color.customPurple.clipShape(Circle()))
                        .overlay(
                            Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .offset(x: -5, y: -5)
                }
            }
            .padding()
        }
        .onChange(of: avatarItem) { newItem in
            if let newItem = newItem {
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        avatarImage = Image(uiImage: uiImage)
                        profileSettingsViewModel.profileImage = Image(uiImage: uiImage)
                    } else {
                        print("Failed to load image.")
                    }
                }
            }
        }
    }
    
    private var changeUserDataSection: some View {
        VStack(spacing: 20) {
            LabeledTextFieldView(label: "Email", placeholder: "", text: $profileSettingsViewModel.email)
            
            Button(action: {
                profileSettingsViewModel.updateProfile()
            }) {
                Text("Update profile")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.customPurple)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
    }
}

#Preview {
    ProfileSettingsView()
}
