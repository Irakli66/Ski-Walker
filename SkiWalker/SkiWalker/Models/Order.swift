//
//  Order.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import Foundation

struct Order: Codable {
    let id: String
    let date: Date
    let status: OrderStatus
    let deliveryAddress: String
    let totalPrice: Double
    let products: [Product]
    let payment: String
}

enum OrderStatus: String, Codable {
    case inProgress = "In Progress"
    case delivered = "Delivered"
    case rejected = "Rejected"
}
