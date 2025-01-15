//
//  User.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 15.01.25.
//
import Foundation

struct User: Codable {
    let id: String
    let firstname: String?
    let lastname: String?
    let companyName: String?
    let companyId: String?
    let email: String
    let role: UserRole
}

enum UserRole: String, Codable, Hashable {
    case customer = "Customer"
    case vendor = "Vendor"
}
