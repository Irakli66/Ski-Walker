//
//  LabeledTextFieldView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import SwiftUI

struct LabeledTextFieldView: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(Color.customWhite)
            
            TextField(placeholder, text: $text)
                .padding(10)
                .background(Color.customWhite)
                .cornerRadius(8)
                .shadow(radius: 2)
        }
    }
}
