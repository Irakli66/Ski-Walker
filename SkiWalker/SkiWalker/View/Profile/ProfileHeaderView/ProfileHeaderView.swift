//
//  ProfileHeaderView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 30.01.25.
//

import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: viewModel.user?.photo?.url ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                case .success(let image):
                    image
                        .profileImageModifier(size: 80, foregroundColor: .clear)
                case .failure:
                    Image(systemName: "person.crop.circle.fill")
                        .profileImageModifier(size: 80, foregroundColor: .customPurple)
                @unknown default:
                    Image(systemName: "exclamationmark.triangle.fill")
                        .profileImageModifier(size: 50)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(viewModel.user?.firstname ?? "") \(viewModel.user?.lastname ?? "")")
                    .font(.system(size: 22, weight: .bold))
                Text(viewModel.user?.email ?? "")
                    .font(.system(size: 14))
                    .foregroundStyle(.customGrey)
            }
            Spacer()
        }
    }
}

#Preview {
    ProfileHeaderView()
}
