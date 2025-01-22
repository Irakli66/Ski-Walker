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
    @State private var selectedDate: Date = Date()
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
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    deliveryAddressSection
                    deliveryDateSection
                    Divider()
                    productsSection
                    paymentSection
                    Spacer()
                    orderDetailsSection
                }
            }
        }
        .padding(.horizontal)
        .background(Color.customBackground)
        .onAppear() {
            getCheckoutItems()
        }
    }
    
    private var deliveryAddressSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Delivery Details")
                .font(.system(size: 16, weight: .bold))
            HStack(alignment: .center) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundStyle(Color.customPurple)
                    .font(.system(size: 28))
                VStack(alignment: .leading) {
                    Text("John Doe")
                        .font(.system(size: 14, weight: .bold))
                    Text("25 John Doe, Tbilis, Georgia")
                        .font(.system(size: 13, weight: .regular))
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var deliveryDateSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Pick delivery date:")
                .font(.system(size: 13, weight: .regular))
            HStack {
                ForEach(checkoutViewModel.deliveryDates, id: \.self) { date in
                    VStack {
                        Text(checkoutViewModel.formatDateToDayAndMonth(date))
                            .foregroundStyle(date == selectedDate ? Color.customWhite : Color.customPurple)
                            .font(.system(size: 13, weight: .regular))
                        Text("FREE")
                            .foregroundStyle(Color.green)
                            .font(.system(size: 13, weight: .regular))
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    .background(date == selectedDate ? Color.customPurple : Color.customWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .onTapGesture {
                        selectedDate = date
                    }
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var productsSection: some View {
        LazyHStack {
            ScrollView(.horizontal) {
                ForEach(checkoutViewModel.cartItems, id: \.self.id) { item in
                    ReusableAsyncImageView(url: item.product.photos[0].url)
                }
            }
        }
    }
    
    private var paymentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Payment Method")
                .font(.system(size: 16, weight: .bold))
            HStack(alignment: .center) {
                Image(systemName: "creditcard")
                    .foregroundStyle(Color.customPurple)
                    .font(.system(size: 24))
                VStack(alignment: .leading) {
                    Text("Credit Cart")
                        .font(.system(size: 13, weight: .regular))
                    Text("4567 **** **** 657")
                        .font(.system(size: 13, weight: .regular))
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var orderDetailsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Order")
                .font(.system(size: 16, weight: .bold))
            HStack {
                Text("Product (2)")
                    .font(.system(size: 14, weight: .regular))
                Spacer()
                Text("260")
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
                Text("260")
                    .font(.system(size: 14, weight: .regular))
            }
            Button(action: {
                print(selectedDate)
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
        
    
    private func getCheckoutItems() {
        Task {
            if let id = productId, let quantity = quantity {
                print("id: \(id), quantity: \(quantity)")
            } else {
               await checkoutViewModel.fetchCart()
            }
        }
    }
}

#Preview {
    CheckoutView(productId: nil, quantity: nil)
}
