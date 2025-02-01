//
//  BrowsingHistoryItem.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 25.01.25.
//
import Foundation

struct BrowsingHistoryItem: Codable {
    let id: String
    let imageURL: String
    let name: String
    let finalPrice: Double
}
