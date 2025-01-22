//
//  Cart.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 18.01.25.
//

struct Cart: Codable {
    let productInCarts: [CartItem]
}

struct CartItem: Codable {
    let id: String
    let count: Int
    let product: CartProduct
}

struct CartProduct: Codable {
    let id: String
    let name: String
    let stock: Int
    let finalPrice: Double
    let photos: [Photo]
    let favorite: Bool
}
