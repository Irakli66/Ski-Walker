//
//  CreditCard.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import Foundation

struct CreditCard: Codable {
    var id: UUID = UUID()
    let fullName: String
    let number: String
    let validThru: String
    let cvc: String
}
