//
//  OrderHistoryViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import Foundation

final class OrderHistoryViewModel {
    private lazy var orders: [Order] = []
    
    func getOrderCount() -> Int {
        orders.count
    }
    
    func getOrderAt(index: Int) -> Order {
        orders[index]
    }
}
