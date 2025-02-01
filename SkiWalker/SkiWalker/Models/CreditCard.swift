//
//  CreditCard.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import Foundation

struct CreditCard: Codable {
    let id: String
    let fullname: String
    let cardNumber: String
    let validThru: String
    let cvc: String
}
