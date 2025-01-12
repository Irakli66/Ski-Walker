//
//  OrderHistoryViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import Foundation

final class OrderHistoryViewModel {
    private let sampleProduct = Product(
        id: UUID().uuidString,
        vendorId: "vendor123",
        name: "Ski Jacket",
        description: "Waterproof and warm ski jacket.",
        category: .clothing,
        price: 130.0,
        discount: 10.0,
        stock: 20,
        rentable: true,
        rentalPrice: 20.0,
        rentalStock: 5,
        imageURLs: ["person.fill"]
    )
    private lazy var orders: [Order] = [Order(id: "3674", date: Date(), status: .delivered, deliveryAddress: "25 john doe, Tbilisi, Georgia", totalPrice: 130, products: [sampleProduct], payment: "Credit Card")]
    
    func getOrderCount() -> Int {
        orders.count
    }
    
    func getOrderAt(index: Int) -> Order {
        orders[index]
    }
}
