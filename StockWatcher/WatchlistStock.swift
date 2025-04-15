//
//  WatchListStock.swift
//  StockWatcher
//
//  Created by Vidyut Veedgav on 4/15/25.
//

import Foundation
import SwiftData

@Model
class WatchlistStock: Identifiable, Hashable {
    var id = UUID()
    var symbol: String
    var price: String
    var change: String
    var changePercent: String
    
    init(id: UUID = UUID(), symbol: String, price: String, change: String, changePercent: String) {
        self.id = id
        self.symbol = symbol
        self.price = price
        self.change = change
        self.changePercent = changePercent
    }
}
