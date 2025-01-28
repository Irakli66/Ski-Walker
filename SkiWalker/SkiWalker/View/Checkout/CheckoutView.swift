//
//  CheckoutView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 22.01.25.
//

import SwiftUI

struct CheckoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var checkoutViewModel = CheckoutViewModel()
    let productId: String?
    let quantity: Int?
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            ZStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .imageScale(.large)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                
                Text("Checkout")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.customPurple)
            }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 30) {
                    DeliveryAddressView()
                    deliveryDateSection
                    Divider()
                    productsSection
                    OrderPaymentsView()
                    Spacer()
                    orderDetailsSection
                }
            }
        }
        .padding(.horizontal)
        .background(Color.customBackground)
        .onAppear() {
            getCheckoutData()
        }
        .environmentObject(checkoutViewModel)
    }
    
    private var deliveryDateSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Pick delivery date:")
                .font(.system(size: 13, weight: .regular))
            HStack {
                ForEach(checkoutViewModel.deliveryDates, id: \.self) { date in
                    VStack {
                        Text(checkoutViewModel.formatDateToDayAndMonth(date))
                            .foregroundStyle(date == checkoutViewModel.selectedDate ? Color.customWhite : Color.customPurple)
                            .font(.system(size: 13, weight: .regular))
                        Text("FREE")
                            .foregroundStyle(Color.green)
                            .font(.system(size: 13, weight: .regular))
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    .background(date == checkoutViewModel.selectedDate ? Color.customPurple : Color.customWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .onTapGesture {
                        checkoutViewModel.selectedDate = date
                    }
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var productsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(checkoutViewModel.cartItems, id: \.self.id) { item in
                    ReusableAsyncImageView(url: item.product.photos[0].url)
                }
            }
        }
    }
    
    private var orderDetailsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Order")
                .font(.system(size: 16, weight: .bold))
            HStack {
                Text("Product (\(checkoutViewModel.getCartTotalItemCount()))")
                    .font(.system(size: 14, weight: .regular))
                Spacer()
                Text(checkoutViewModel.getTotalPriceFormatted())
                    .font(.system(size: 14, weight: .regular))
            }
            HStack {
                Text("Delivery price")
                    .font(.system(size: 14, weight: .regular))
                Spacer()
                Text("FREE")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.green)
            }
            HStack {
                Text("Order total")
                    .font(.system(size: 14, weight: .regular))
                Spacer()
                Text(checkoutViewModel.getTotalPriceFormatted())
                    .font(.system(size: 14, weight: .regular))
            }
            Button(action: {
                makePayment()
            }) {
                Text("Pay")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.customWhite)
                    .padding()
                    .background(Color.customPurple)
                    .cornerRadius(10)
                
            }
        }
    }
    
    
    private func getCheckoutData() {
        Task {
            if let id = productId, let quantity = quantity {
                await checkoutViewModel.fetchSingleProduct(with: id)
                checkoutViewModel.createTemporaryCartItem(with: quantity)
            } else {
                await checkoutViewModel.fetchCart()
            }
            
            await checkoutViewModel.fetchAddresses()
            await checkoutViewModel.fetchPaymentMethods()
        }
    }
    
    private func makePayment() {
        Task {
            do {
                if let productId = productId, let quantity = quantity {
                    try await checkoutViewModel.buyNowPayment(productId: productId, quantity: quantity)
                } else {
                    try await checkoutViewModel.cartPayment()
                }
                AlertManager.showAlertWithActions(title: "Payment Succesful", message: "Navigate back", actions: [UIAlertAction(title: "OK", style: .default) { _ in
                    presentationMode.wrappedValue.dismiss()
                }])
            } catch {
                print(error.localizedDescription)
                
                AlertManager.showAlert(title: "Payment Failed", message: "check your funds")
            }
        }
    }
}

#Preview {
    CheckoutView(productId: nil, quantity: nil)
}
