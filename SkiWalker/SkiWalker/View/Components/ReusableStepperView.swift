//
//  ReusableStepperView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 18.01.25.
//

import SwiftUI

struct ReusableStepperView: View {
    let stock: Int
    @Binding var quantity: Int
    var body: some View {
        HStack {
            Button(action: {
                if quantity > 1 {
                    quantity -= 1
                }
            }) {
                Image(systemName: "minus.circle.fill")
                    .font(.title2)
                    .foregroundColor(quantity > 1 ? Color.customPurple : Color.gray)
            }
            
            Text("\(quantity)")
                .font(.headline)
                .frame(minWidth: 40)

            Button(action: {
                if quantity < stock {
                    quantity += 1
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(quantity < stock ? Color.customPurple : Color.gray)
            }
        }
        .padding(8)
        .background(Color.customPurple.opacity(0.1))
        .cornerRadius(10)
    }
}

