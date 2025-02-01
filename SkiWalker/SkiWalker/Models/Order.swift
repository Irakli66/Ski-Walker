//
//  Order.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import Foundation

struct OrderResponse: Codable {
    let id: String
    let status: OrderStatus
    let createdAt: String
    let products: [CartItem]
    let totalPrice: Double
    let lastUpdatedAt: String
    let shippingAddress: Address
    let paymentMethodId: String
}

enum OrderStatus: Int, Codable {
    case inProgress = 0
    case shipped = 1
    case delivered = 2
    case cancelled = 3

    var displayName: String {
        switch self {
        case .inProgress:
            return "In Progress"
        case .shipped:
            return "Shipped"
        case .delivered:
            return "Delivered"
        case .cancelled:
            return "Cancelled"
        }
    }
}
