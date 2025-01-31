//
//  CheckoutStatusView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 31.01.25.
//

import SwiftUI

struct CheckoutStatusView: View {
    let paymentStatus: PaymentStatus
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if paymentStatus == .success {
            succesSection
        } else {
            failureSection
        }
    }
    
    @ViewBuilder
    private var succesSection: some View {
        VStack {
            Spacer()
            Text("Payment Successful! 🎉")
                .font(.system(size: 18))
            Text("Thanks for purchase")
                .font(.system(size: 16))
            
            
            Image("success")
                .resizable()
                .frame(width: 200, height: 200)
            
            NavigationLink(destination: OrderHistoryView().navigationBarBackButtonHidden().background(.customBackground)) {
                Text("Check your orders here!")
                    .font(.system(size: 16))
                    .foregroundStyle(.customPurple)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.customWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.customGrey, lineWidth: 1)
                    )
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.customBackground)
    }
    
    @ViewBuilder
    private var failureSection: some View {
        VStack {
            HStack {
                ReusableBackButton()
                Spacer()
            }
            .padding(.horizontal, 20)
            Spacer()
            Text("Payment Failed! ❌")
                .font(.system(size: 18))
            
            Text("Check your funds and try again")
                .font(.system(size: 14))
            
            Image("failed")
                .resizable()
                .frame(width: 200, height: 200)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.customBackground)
    }
}

enum PaymentStatus: String {
    case success = "Success"
    case failed = "Failed"
}

//#Preview {
//    CheckoutStatusView()
//}
