//
//  BrowsingHistoryManager.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 25.01.25.
//
import SwiftUI

protocol BrowsingHistoryManagerProtocol {
    func addToBrowsingHistory(id: String, imageURL: String, name: String, finalPrice: Double)
    func getBrowsingHistory() -> [BrowsingHistoryItem]
}

final class BrowsingHistoryManager: BrowsingHistoryManagerProtocol, ObservableObject {
    @AppStorage("browsingHistory") private var browsingHistoryData: Data = Data()
    
    func addToBrowsingHistory(id: String, imageURL: String, name: String, finalPrice: Double) {
        var browsingHistory: [BrowsingHistoryItem] = []
        
        if let decodedData = try? JSONDecoder().decode([BrowsingHistoryItem].self, from: browsingHistoryData) {
            browsingHistory = decodedData
        }
        
        let newItem = BrowsingHistoryItem(
            id: id,
            imageURL: imageURL,
            name: name,
            finalPrice: finalPrice
        )
        
        if let existingIndex = browsingHistory.firstIndex(where: { $0.id == id }) {
            browsingHistory.remove(at: existingIndex)
        }
        
        browsingHistory.insert(newItem, at: 0)
        
        if browsingHistory.count > 10 {
            browsingHistory.removeLast()
        }
        
        if let encodedData = try? JSONEncoder().encode(browsingHistory) {
            browsingHistoryData = encodedData
        }
    }
    
    func getBrowsingHistory() -> [BrowsingHistoryItem] {
        if let decodedData = try? JSONDecoder().decode([BrowsingHistoryItem].self, from: browsingHistoryData) {
            return decodedData
        }
        return []
    }
}
