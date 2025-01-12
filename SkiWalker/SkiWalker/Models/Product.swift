//
//  Product.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import Foundation

struct Product: Codable {
    let id: String
    let vendorId: String
    let name: String
    let description: String
    let category: ProductCategory
    let price: Double
    let discount: Double?
    var finalPrice: Double {
        if let discount = discount {
            return price - (price * discount / 100)
        }
        return price
    }
    let stock: Int
    let rentable: Bool?
    let rentalPrice: Double?
    let rentalStock: Int?
    let imageURLs: [String]
}

enum ProductCategory: String, Codable {
    case ski
    case snowboard
    case snowmobile
    case snowshoe
    case skiwear
    case clothing
    case snowmobilewear
    case snowshoewear
}

