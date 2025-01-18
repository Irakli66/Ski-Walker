//
//  ButtonModifier.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 18.01.25.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.customWhite)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.customPurple)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
    }
}

extension View {
    public func buttonModifier() -> some View {
        self.modifier(ButtonModifier())
    }
}
