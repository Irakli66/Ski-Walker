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
    @Published var cartItems: [CartItem] = []
    @Published var singleProduct: Product?
    
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
            let response: Product? = try await authenticatedRequestHandler.sendRequest(urlString: url, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
            
            await MainActor.run {
                singleProduct = response
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func formatDateToDayAndMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
}
