//
//  CategoryTitleModifier.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 01.02.25.
//
import SwiftUI

struct CategoryTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(Color.customBlack)
    }
}

extension View {
    public func categoryTitleModifier() -> some View {
        self.modifier(CategoryTitleModifier())
    }
}

