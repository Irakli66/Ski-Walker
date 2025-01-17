//
//  Product.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import Foundation

struct ProductsResponse: Codable {
    let collection: [Product]
    let page: Int
    let pages: Int
    let pageSize: Int
    let totalItemCount: Int
}

struct Product: Codable, Equatable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let stock: Int
    let discount: Double?
    let finalPrice: Double
    let rentable: Bool?
    let rentalPrice: Double?
    let rentalStock: Int?
    let category: String
    let subcategory: String?
    let vendorId: String
    let photos: [Photo]
}

struct Photo: Codable, Equatable {
    let id: String
    let name: String?
    let url: String
}

enum ProductCategory: String, Codable, CaseIterable {
    case ski = "Ski"
    case snowboard = "Snow Board"
    case clothing = "Clothing"
    
    var subcategories: [ProductSubCategory] {
        switch self {
        case .ski:
            return []
        case .snowboard:
            return []
        case .clothing:
            return [.jacket, .pant, .glove, .boot, .helmet]
        }
    }
    
    var iconName: String {
        switch self {
        case .ski: return "ski"
        case .snowboard: return "snowboard"
        case .clothing: return "clothing"
        }
    }
}

enum ProductSubCategory: String, Codable, CaseIterable {
    case jacket = "Jackets"
    case pant = "Pants"
    case glove = "Gloves"
    case boot = "Boots"
    case helmet = "Helmets"
    
    var iconName: String {
        switch self {
        case .jacket: return "jackets"
        case .pant: return "pants"
        case .glove: return "gloves"
        case .boot: return "boots"
        case .helmet: return "helmets"
        }
    }
}
