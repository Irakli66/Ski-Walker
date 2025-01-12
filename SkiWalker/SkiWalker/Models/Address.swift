//
//  Address.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import Foundation

struct Address: Codable {
    let id: String
    let country: String
    let city: String
    let street: String
    let postalCode: String
    let fullName: String
}
