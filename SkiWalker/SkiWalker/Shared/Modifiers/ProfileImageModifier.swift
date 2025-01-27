//
//  ProfileImageModifier.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 27.01.25.
//
import SwiftUI

struct ProfileImageModifier: ViewModifier {
    var size: CGFloat = 125
    var foregroundColor: Color = .red
    var shadowRadius: CGFloat = 2
    
    func body(content: Content) -> some View {
        content
            .frame(width: size, height: size)
            .foregroundColor(foregroundColor)
            .clipShape(Circle())
            .shadow(radius: shadowRadius)
    }
}

extension Image {
    public func profileImageModifier(
        size: CGFloat = 125,
        foregroundColor: Color = .red,
        shadowRadius: CGFloat = 2
    ) -> some View {
        self
            .resizable()
            .scaledToFill()
            .modifier(ProfileImageModifier(size: size, foregroundColor: foregroundColor, shadowRadius: shadowRadius))
    }
}
