//
//  CurrencyFormatter.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 20.01.25.
//
import Foundation

struct CurrencyFormatter {
    static func formatPriceToGEL(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "GEL"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        return formatter.string(from: NSNumber(value: price)) ?? "\(price) ₾"
    }
}
