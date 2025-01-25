//
//  PaymentMethodsView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 11.01.25.
//
import SwiftUI

struct PaymentMethodsView: View {
    @StateObject private var paymentMethodsViewModel = PaymentMethodsViewModel()
    @State private var isSheetPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                paymentsHeader
                
                if !paymentMethodsViewModel.paymentMethods.isEmpty {
                    List(paymentMethodsViewModel.paymentMethods, id: \.id) { card in
                        CreditCardView(card: card)
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 10)
                            .background(Color.customBackground)
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Spacer()
                    Image("emptyCard")
                        .resizable()
                        .frame(width: 200, height: 230)
                }
                
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
            ReusableBackButton()
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
        .onAppear() {
            Task {
                do {
                    try await paymentMethodsViewModel.fetchPaymentMethods()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}



#Preview {
    PaymentMethodsView()
}
