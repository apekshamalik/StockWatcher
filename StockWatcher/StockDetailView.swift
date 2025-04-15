//
//  ContentView.swift
//  StockWatcher
//
//  Created by Apeksha Malik on 4/11/25.
//

import SwiftUI
import Charts
import SwiftData

struct StockDetailView: View {
    
    // Stock details
    @State var symbol: String
    @State var name: String
    @State var isAddMode: Bool = true
    @State var stockDetailModel = StockDetailModel()
    @State var inputSymbol: String
    @State var showFormSheet = false
    @State var showConfirmationSheet = false
    @State var shares = ""
    @State var purchasePrice = ""
    @State var repeatedStock = false
    
    @Query var watchlist: [WatchlistStock]
    
    @Environment(\.modelContext) var modelContext

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Search bar
                    StockSearchView(inputSymbol: $inputSymbol, stockDetailModel: $stockDetailModel)
                    
                    // Symbol header
                    HeaderView(stockDetailModel: $stockDetailModel)
                    
                    // Chart with animation
                    if stockDetailModel.chartData.isEmpty {
                        ProgressView("Loading chart...")
                            .padding()
                    } else {
                        withAnimation {
                            ChartView(stockDetailModel: $stockDetailModel)
                        }
                    }
                    
                    // Price Info with slide-in animation
                    PriceView(stockDetailModel: $stockDetailModel)
                    Spacer()
                    
                    if isAddMode {
                        Spacer()
                        Button(action: {
                            let normalizedSymbol = inputSymbol.uppercased()
                            
                            if let open = stockDetailModel.quote?.open {
                                purchasePrice = open
                            } else if let close = stockDetailModel.quote?.close {
                                purchasePrice = close
                            } else {
                                purchasePrice = "0.00"
                            }

                            repeatedStock = watchlist.contains(where: { $0.symbol == normalizedSymbol })

                            withAnimation(.spring()) {
                                showFormSheet = true
                            }
                        }) {
                            Text("Add to Portfolio")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .scaleEffect(showFormSheet ? 1.05 : 1.0)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.white)
            .task {
                await stockDetailModel.load(symbol: symbol)
            }
            
            // Form sheet
            .sheet(isPresented: $showFormSheet) {
                ConfirmationView(
                    showFormSheet: $showFormSheet,
                    purchasePrice: $purchasePrice,
                    inputSymbol: $inputSymbol,
                    showConfirmationSheet: $showConfirmationSheet,
                    repeatedStock: $repeatedStock,
                    change: stockDetailModel.quote?.change ?? "+0.00",
                    changePercent: stockDetailModel.quote?.percent_change ?? "0.00%"
                )
            }
            
            .sheet(isPresented: $showConfirmationSheet) {
                VStack(spacing: 20) {
                    
                    if repeatedStock {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.orange)
                        
                        Text("This stock is already in your portfolio.")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        Text("Stock successfully added!")
                    }
                    
                    Button("Close") {
                        showConfirmationSheet = false
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    StockDetailView(symbol: "AAPL", name: "Apple", inputSymbol: "AAPL")
}
