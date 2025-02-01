//
//  ValidThruTextField.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import SwiftUI

struct ValidThruTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(LocalizedStringKey(label))
                .font(.subheadline)
                .foregroundColor(.customPurple)
            
            TextField(LocalizedStringKey(placeholder), text: $text)
                .keyboardType(.numberPad)
                .padding(10)
                .background(Color.customWhite)
                .cornerRadius(8)
                .shadow(radius: 2)
                .onChange(of: text) { newValue in
                    text = formatValidThruInput(newValue)
                }
        }
    }
    
    private func formatValidThruInput(_ input: String) -> String {
        let filtered = input.filter { $0.isNumber }
        if filtered.count >= 1 && filtered.count <= 2 {
            let month = Int(filtered) ?? 0
            if month > 12 {
                return "12"
            }
            return filtered
        } else if filtered.count > 2 {
            let month = Int(filtered.prefix(2)) ?? 0
            let correctedMonth = min(max(month, 1), 12)
            let year = String(filtered.dropFirst(2).prefix(2))
            return String(format: "%02d/%@", correctedMonth, year)
        }
        return filtered
    }
}
