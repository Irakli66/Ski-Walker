//
//  CheckoutViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 22.01.25.
//

import SwiftUI

final class CheckoutViewModel: ObservableObject {
    private let cartManager: CartManagerProtocol
    private let authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol
    private let today = Date()
    @Published var addresses: [Address] = []
    @Published var paymentMethods: [CreditCard] = []
    @Published var cartItems: [CartItem] = []
    @Published var singleProduct: CartProduct?
    
    var deliveryDates: [Date] {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today
        let dayAfterTomorrow = calendar.date(byAdding: .day, value: 2, to: today) ?? today
        
        return [today, tomorrow, dayAfterTomorrow]
    }
    
    
    init(cartManager: CartManagerProtocol = CartManager(), authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler()) {
        self.cartManager = cartManager
        self.authenticatedRequestHandler = authenticatedRequestHandler
    }
    
    func fetchCart() async {
        do {
            let response = try await cartManager.fetchCartItems()
            await MainActor.run {
                cartItems = response
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchSingleProduct(with id: String) async {
        let url = "https://api.gargar.dev:8088/Product/\(id)"
        
        do {
            let response: CartProduct? = try await authenticatedRequestHandler.sendRequest(urlString: url, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
            
            await MainActor.run {
                singleProduct = response
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createTemporaryCartItem(with quantity: Int) {
        guard let product = singleProduct else {
            return
        }
        let temporaryCartItem = CartItem(id: UUID().uuidString, count: quantity, product: product)
        
        cartItems = [temporaryCartItem]
    }
    
    func fetchAddresses() async {
        let url = "https://api.gargar.dev:8088/Shipping"
        
        do {
            let response: [Address]? = try await authenticatedRequestHandler.sendRequest(urlString: url, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
            
            guard let addressesResponse = response else {
                fatalError("Failed to fetch payment methods: No data received.")
            }
            
            await MainActor.run {
                addresses = addressesResponse
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchPaymentMethods() async {
        let url = "https://api.gargar.dev:8088/Payment"
        
        do {
            let response: [CreditCard]? = try await authenticatedRequestHandler.sendRequest(
                urlString: url,
                method: .get,
                headers: nil,
                body: nil,
                decoder: JSONDecoder()
            )
            
            guard let creditCards = response else {
                fatalError("Failed to fetch payment methods: No data received.")
            }
            
            await MainActor.run {
                paymentMethods = creditCards
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getCartTotalItemCount() -> String {
        let totalItems = cartItems.reduce(0) { $0 + $1.count }
        return String(totalItems)
    }
    
    func getTotalPriceFormatted() -> String {
        let totalPrice = cartItems.reduce(0) { $0 + Double($1.count) * $1.product.finalPrice }
        return CurrencyFormatter.formatPriceToGEL(totalPrice)
    }
    
    func formatDateToDayAndMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
}
