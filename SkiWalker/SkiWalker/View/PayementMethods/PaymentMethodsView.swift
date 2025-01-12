//
//  PaymentMethodsView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 11.01.25.
//
import SwiftUI

struct PaymentMethodsView: View {
    private let paymentMethodsViewModel = PaymentMethodsViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var isSheetPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                paymentsHeader
                List(paymentMethodsViewModel.paymentMethods, id: \.number) { card in
                    CreditCardView(card: card)
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical, 10)
                        .background(Color.customBackground)
                }
                .listStyle(PlainListStyle())
                Spacer()
            }
            .padding()
            .background(Color.customBackground)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $isSheetPresented) {
                AddCreditCardView()
                    .presentationDetents([.height(430)])
                    .background(Color.customBackground)
            }
            .environmentObject(paymentMethodsViewModel)
        }
    }
    
    private var paymentsHeader: some View {
        HStack {
            Image(systemName: "chevron.left")
                .onTapGesture {
                    dismiss()
                }
            Spacer()
            Text("Payment Methods")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.customPurple)
            Spacer()
            Image(systemName: "plus")
                .font(.system(size: 20))
                .onTapGesture {
                    isSheetPresented = true
                }
        }
    }
}



#Preview {
    PaymentMethodsView()
}
