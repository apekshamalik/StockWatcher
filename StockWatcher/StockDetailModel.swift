//
//  StockDetailViewModel.swift
//  StockWatcher
//
//  Created by Apeksha Malik on 4/12/25.
//

import Foundation
import SwiftUI

func fetchTimeSeries(for symbol: String) async throws -> [TimeSeriesData] {
    let urlString = "https://api.twelvedata.com/time_series?symbol=\(symbol)&interval=1day&outputsize=30&apikey=8d8137060ef648309c7c6fb163f5a5c6"

    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)

    let decoder = JSONDecoder()
    let response = try decoder.decode(TimeSeriesResponse.self, from: data)

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"

    return response.values.compactMap { point in
        guard let date = formatter.date(from: point.datetime),
              let close = Double(point.close) else {
            return nil
        }
        return TimeSeriesData(date: date, closePrice: close)
    }.reversed()
}

func fetchStockQuote(symbol: String) async throws -> StockQuote {
    let urlString = "https://api.twelvedata.com/quote?symbol=\(symbol)&apikey=8d8137060ef648309c7c6fb163f5a5c6"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    print(String(data: data, encoding: .utf8) ?? "No response")
    let decoder = JSONDecoder()
    return try decoder.decode(StockQuote.self, from: data)
}


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

@Observable
class StockDetailModel {
    var chartData: [TimeSeriesData] = []
    var quote: StockQuote?
    var error: String?

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
