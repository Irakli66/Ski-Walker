//
//  APIEndpoints.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 01.02.25.
//

import Foundation

enum APIEndpoints {
    static let baseURL = "https://api.gargar.dev:8088"
    
    enum Auth {
        static let login = "\(APIEndpoints.baseURL)/login"
        static let registerUser = "\(APIEndpoints.baseURL)/Auth/registerUser"
        static let registerVendor = "\(APIEndpoints.baseURL)/Auth/registerVendor"
        static let forgotPassword = "\(APIEndpoints.baseURL)/forgotPassword"
        static let resetPassword = "\(APIEndpoints.baseURL)/resetPassword"
    }
    
    enum Product {
        static let all = "\(APIEndpoints.baseURL)/Product"
        static func details(for id: String) -> String { "\(APIEndpoints.baseURL)/Product/\(id)" }
        static let popular = "\(APIEndpoints.baseURL)/Product/popilar"
        static let onSale = "\(APIEndpoints.baseURL)/Product/onSale"
        static let favorites = "\(APIEndpoints.baseURL)/Product/favorites"
        
        static func addToFavorites(productId: String) -> String {
            "\(APIEndpoints.baseURL)/Product/\(productId)/favorites"
        }
        
        static func deleteFromFavorites(productId: String) -> String {
            "\(APIEndpoints.baseURL)/Product/\(productId)/favorites"
        }
    }
    
    enum User {
        static func details(for id: String) -> String { "\(APIEndpoints.baseURL)/User/\(id)" }
        static let currentUser = "\(APIEndpoints.baseURL)/User/current"
        static let updateProfile = "\(APIEndpoints.baseURL)/User"
        static let updateProfileImage = "\(APIEndpoints.baseURL)/Photo"
    }
    
    enum Cart {
        static let fetch = "\(APIEndpoints.baseURL)/Cart"
        static func add(productId: String, count: Int) -> String {
            "\(APIEndpoints.baseURL)/Cart/\(productId)?count=\(count)"
        }
        static func delete(productId: String) -> String {
            "\(APIEndpoints.baseURL)/Cart/\(productId)"
        }
    }
    
    enum Order {
        static let history = "\(APIEndpoints.baseURL)/Order"
        static let checkoutCart = "\(APIEndpoints.baseURL)/Order/Checkout/Cart"
        static let checkoutBuyNow = "\(APIEndpoints.baseURL)/Order/Checkout"
    }
    
    enum Payment {
        static let fetch = "\(APIEndpoints.baseURL)/Payment"
        static let add = "\(APIEndpoints.baseURL)/Payment"
        static func remove(cardId: String) -> String { "\(APIEndpoints.baseURL)/Payment/\(cardId)" }
    }
    
    enum Shipping {
        static let fetch = "\(APIEndpoints.baseURL)/Shipping"
        static let add = "\(APIEndpoints.baseURL)/Shipping"
        static func remove(addressId: String) -> String { "\(APIEndpoints.baseURL)/Shipping/\(addressId)" }
    }
}
