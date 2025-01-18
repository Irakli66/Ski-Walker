//
//  ReusableAsyncImageView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 18.01.25.
//
import SwiftUI

struct ReusableAsyncImageView: View {
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 100, height: 100)
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.customGrey)
                    .frame(width: 100, height: 100)
                
            @unknown default:
                EmptyView()
            }
        }
    }
}
