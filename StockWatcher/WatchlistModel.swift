//
//  WatchlistModel.swift
//  StockWatcher
//
//  Created by Apeksha Malik on 4/13/25.
//

import Foundation

class WatchlistModel: ObservableObject {
    @Published var stocks: [WatchlistStock] = []

    func addStock(symbol: String, price: String, change: String = "+0.00", changePercent: String = "0.00%") {
        let newStock = WatchlistStock(symbol: symbol.uppercased(), price: price, change: change, changePercent: changePercent)
        stocks.append(newStock)
    }
}
