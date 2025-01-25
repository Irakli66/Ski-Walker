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
    let products: [CartProduct]
    let totalPrice: Int
    let lastUpdatedAt: String
    let shippingAddress: Address
    let paymentMethodId: String?
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
//0 in progress
//1 shipped
//2 delivered
//3 cancelled
