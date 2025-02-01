//
//  AlertModifier.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 01.02.25.
//
import SwiftUI

struct AlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    var title: String
    var message: String
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented, actions: {
                Button("OK", role: .cancel) { }
            }, message: {
                Text(message)
            })
    }
}

extension View {
    func customAlert(isPresented: Binding<Bool>, title: String, message: String) -> some View {
        self.modifier(AlertModifier(isPresented: isPresented, title: title, message: message))
    }
}
