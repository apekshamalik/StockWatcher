//
//  StockWatcherApp.swift
//  StockWatcher
//
//  Created by Apeksha Malik on 4/11/25.
//

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

@main
struct StockWatcherApp: App {
    @StateObject private var watchlistModel = WatchlistModel()

    var body: some Scene {
        WindowGroup {
             ContentView()
                .environmentObject(watchlistModel)
        }
    }
}
