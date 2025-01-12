//
//  CreditCardView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import SwiftUI

struct CreditCardView: View {
    @EnvironmentObject var viewModel: PaymentMethodsViewModel
    let card: CreditCard
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.purple, .blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
                .frame(height: 150)
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 15) {
                HStack{
                    Text("**** **** **** \(card.number.suffix(4))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "trash")
                        .foregroundStyle(.customWhite)
                        .onTapGesture {
                            viewModel.removeCreditCard(with: card.id)
                        }
                }
                
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey("Card Holder"))
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(card.fullName)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Valid Thru")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(card.validThru)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
        }
        .padding(.horizontal)
    }
}

#Preview {
    CreditCardView(card: CreditCard(fullName: "John Does", number: "1234 5678 9012 3456", validThru: "26/30", cvc: "363"))
}
