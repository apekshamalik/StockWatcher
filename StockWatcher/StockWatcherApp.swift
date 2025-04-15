//
//  StockWatcherApp.swift
//  StockWatcher
//
//  Created by Apeksha Malik on 4/11/25.
//

import SwiftUI
import SwiftData

@main
struct StockWatcherApp: App {
    var body: some Scene {
        WindowGroup {
             ContentView()
        }
        .modelContainer(for: WatchlistStock.self)
    }
}
