////
////  WatchlistModel.swift
////  StockWatcher
////
////  Created by Apeksha Malik on 4/13/25.
////
//
//import Foundation
//import SwiftData
//
//class WatchlistModel {
//    
//    var stocks: [WatchlistStock] = []
//    
//    init(stocks: [WatchlistStock]) {
//        self.stocks = stocks
//    }
//
//    func addStock(symbol: String, price: String, change: String = "+0.00", changePercent: String = "0.00%") {
//        let newStock = WatchlistStock(symbol: symbol.uppercased(), price: price, change: change, changePercent: changePercent)
//        stocks.append(newStock)
//    }
//}
