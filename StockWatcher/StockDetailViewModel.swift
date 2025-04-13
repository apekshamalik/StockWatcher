//
//  StockDetailViewModel.swift
//  StockWatcher
//
//  Created by Apeksha Malik on 4/12/25.
//

import Foundation

struct TimeSeriesResponse: Codable {
    let values: [TimeSeriesPoint]
}

struct TimeSeriesData: Identifiable {
    let id = UUID()
    let date: Date
    let closePrice: Double
}

struct TimeSeriesPoint: Codable {
    let datetime: String
    let close: String
}

struct StockQuote: Codable {
    let symbol: String
    let name: String
    let open: String
    let high: String
    let low: String
    let close: String
    let previous_close: String
    let volume: String
    let change: String
    let percent_change: String
    let average_volume: String
    let is_market_open: Bool
}


class StockDetailViewModel: ObservableObject {
    @Published var chartData: [TimeSeriesData] = []
    @Published var quote: StockQuote?
    @Published var error: String?

    func load(symbol: String) async {
            do {
                async let chart = fetchTimeSeries(for: symbol)
                async let quoteData = fetchStockQuote(symbol: symbol)

                self.chartData = try await chart
                self.quote = try await quoteData
            } catch {
                self.error = "Failed to load data"
            }
        }
}
