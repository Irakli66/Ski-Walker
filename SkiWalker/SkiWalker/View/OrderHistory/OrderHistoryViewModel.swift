//
//  OrderHistoryViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import Foundation

final class OrderHistoryViewModel {
    private let authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol
    private lazy var orders: [OrderResponse] = []
    
    init(authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler()) {
        self.authenticatedRequestHandler = authenticatedRequestHandler
    }
    
    func fetchOrders() async  {
        let url = "https://api.gargar.dev:8088/Order"
        
        do {
            let response: [OrderResponse]? = try await authenticatedRequestHandler.sendRequest(urlString: url, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
            
            if let response = response {
                orders = response.reversed()
            } else {
                orders = []
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func getOrderCount() -> Int {
        orders.count
    }
    
    func getOrderAt(index: Int) -> OrderResponse {
        orders[index]
    }
}
