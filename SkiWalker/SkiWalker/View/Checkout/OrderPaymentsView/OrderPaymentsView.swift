//
//  OrderPaymentsView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 22.01.25.
//

import SwiftUI

struct OrderPaymentsView: View {
    @EnvironmentObject private var checkoutViewModel: CheckoutViewModel
    @State private var showPaymentMethodSheet = false
    @State private var showAddNewPaymentMethod = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Delivery Details")
                .font(.system(size: 16, weight: .bold))
            deliveryContent
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showPaymentMethodSheet) {
            PaymentMethodSelectionSheet(showPaymentMethodsView: $showAddNewPaymentMethod)
                .presentationDetents([.height(450)])
                .background(Color.customBackground)
        }
        .fullScreenCover(isPresented: $showAddNewPaymentMethod) {
            PaymentMethodsView()
        }
    }
    
    @ViewBuilder
    private var deliveryContent: some View {
        if checkoutViewModel.paymentMethods.isEmpty {
            noPaymentMethod
        } else {
            paymentMethodDetails
        }
    }
    
    @ViewBuilder
    private var paymentMethodDetails: some View {
        HStack(alignment: .center) {
            Image(systemName: "creditcard")
                .foregroundStyle(Color.customPurple)
                .font(.system(size: 28))
            
            VStack(alignment: .leading) {
                if let selectedPaymentMethod = checkoutViewModel.selectedPaymentMethod {
                    Text("Credit Card")
                        .font(.system(size: 14, weight: .bold))
                    Text("\(selectedPaymentMethod.cardNumber.prefix(4)) **** **** \(selectedPaymentMethod.cardNumber.suffix(4))")
                        .font(.system(size: 13, weight: .regular))
                }
            }
            
            Spacer()
            Image(systemName: "arrow.up.arrow.down")
        }
        .onTapGesture {
            showPaymentMethodSheet = true
        }
    }
    
    @ViewBuilder
    private var noPaymentMethod: some View {
        HStack(alignment: .center) {
            Image(systemName: "creditcard")
                .foregroundStyle(Color.customPurple)
                .font(.system(size: 28))
            
            VStack(alignment: .leading) {
                Text("You don't have any saved cards.")
                    .font(.system(size: 14, weight: .bold))
                NavigationLink(destination: PaymentMethodsView().navigationBarBackButtonHidden(), label: {
                    Text("Add one here")
                        .font(.system(size: 13, weight: .regular))
                })
            }
            Spacer()
        }
    }
}

struct PaymentMethodSelectionSheet: View {
    @EnvironmentObject private var checkoutViewModel: CheckoutViewModel
    @Environment(\.presentationMode) private var presentationMode
    @Binding var showPaymentMethodsView: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Select payment method")
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.customWhite)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(Color.customPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
            
            paymentMethodsList
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                showPaymentMethodsView = true
            }) {
                Text("Add new payment method")
                    .buttonModifier()
            }
        }
        .padding()
        .onAppear() {
            Task {
                await checkoutViewModel.fetchPaymentMethods()
            }
        }
    }
    
    private var paymentMethodsList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(checkoutViewModel.paymentMethods, id: \.self.id) { card in
                    HStack(alignment: .center) {
                        Image(systemName: "creditcard")
                            .foregroundStyle(Color.customPurple)
                            .font(.system(size: 24))
                        
                        VStack(alignment: .leading) {
                            Text(card.fullname)
                                .font(.system(size: 14, weight: .bold))
                            Text("\(card.cardNumber.prefix(4)) **** **** \(card.cardNumber.suffix(4))")
                                .font(.system(size: 13, weight: .regular))
                        }
                        
                        Spacer()
                    }
                    .onTapGesture {
                        checkoutViewModel.selectedPaymentMethod = card
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    OrderPaymentsView()
}
