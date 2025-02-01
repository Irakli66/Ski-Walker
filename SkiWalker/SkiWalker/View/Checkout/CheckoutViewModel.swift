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
    @Published var selectedAddress: Address?
    @Published var selectedPaymentMethod: CreditCard?
    @Published var selectedDate: Date = Date()
    
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
        let url = APIEndpoints.Product.details(for: id)
        
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
        do {
            let response: [Address]? = try await authenticatedRequestHandler.sendRequest(urlString: APIEndpoints.Shipping.fetch, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
            
            guard let addressesResponse = response else {
                fatalError("Failed to fetch payment methods: No data received.")
            }
            
            await MainActor.run {
                addresses = addressesResponse
                if !addressesResponse.isEmpty {
                    selectedAddress = addressesResponse[0]
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchPaymentMethods() async {
        do {
            let response: [CreditCard]? = try await authenticatedRequestHandler.sendRequest(
                urlString: APIEndpoints.Payment.fetch,
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
                if !creditCards.isEmpty {
                    selectedPaymentMethod = creditCards[0]
                }
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
    
    func cartPayment() async throws {
        guard let address = selectedAddress, let paymentMethod = selectedPaymentMethod, !cartItems.isEmpty else {
            return
        }
        
        let url = APIEndpoints.Order.checkoutCart
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let formattedDate = dateFormatter.string(from: selectedDate)
        
        let requestBody: [String: String] = [
            "date": formattedDate,
            "shippingId": address.id,
            "paymentId": paymentMethod.id,
        ]
        
        let bodyData = try? JSONEncoder().encode(requestBody)
        
        let _: OrderResponse? = try await authenticatedRequestHandler.sendRequest(urlString: url, method: .post, headers: nil, body: bodyData, decoder: JSONDecoder())
        await MainActor.run {
            cartItems = []
        }
    }
    
    func buyNowPayment(productId: String, quantity: Int) async throws {
        guard let address = selectedAddress, let paymentMethod = selectedPaymentMethod, !cartItems.isEmpty else {
            return
        }
        
        let url = APIEndpoints.Order.checkoutBuyNow
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let formattedDate = dateFormatter.string(from: selectedDate)
        
        let requestBody: [String: Any] = [
            "productId": productId,
            "date": formattedDate,
            "shippingId": address.id,
            "paymentId": paymentMethod.id,
            "quantity": quantity,
        ]
        
        let bodyData = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
        
        let _: OrderResponse? = try await authenticatedRequestHandler.sendRequest(urlString: url, method: .post, headers: nil, body: bodyData, decoder: JSONDecoder())
        await MainActor.run {
            cartItems = []
        }
    }
}
