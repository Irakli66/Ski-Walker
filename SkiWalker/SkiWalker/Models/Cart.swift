//
//  Cart.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 18.01.25.
//

struct Cart: Codable {
    let products: [CartItem]
}

struct CartItem: Codable {
    let id: String
    let count: Int
    let product: Product
}
