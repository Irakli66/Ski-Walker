//
//  ToastModifier.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 01.02.25.
//
import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let type: ToastType
    let duration: TimeInterval

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                VStack {
                    HStack {
                        Image(systemName: type == .success ? "checkmark.circle" : "xmark.octagon")
                            .foregroundColor(.white)
                        Text(message)
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                    .background(Color(type.backgroundColor))
                    .cornerRadius(10)
                    .padding(.top, 10)
                    Spacer()
                }
                .transition(.move(edge: .top))
                .animation(.easeInOut, value: isPresented)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String, type: ToastType, duration: TimeInterval = 2.0) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message, type: type, duration: duration))
    }
}
