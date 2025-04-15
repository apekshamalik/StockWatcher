import SwiftUI
import SwiftData

struct WatchlistView: View {
    @Query var stocks: [WatchlistStock]
    @State private var quotes: [String: StockQuote] = [:]
    @Environment(\.modelContext) var modelContext
    
    func deleteStock(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(stocks[index])
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(stocks) { stock in
                    if let quote = quotes[stock.symbol] {
                        NavigationLink(destination: StockDetailView(symbol: quote.symbol, name: quote.name, inputSymbol: quote.symbol)) {
                            StockRowView(stock: stock)
                        }
                        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))

                    } else {
                        // Placeholder
                        HStack {
                            ProgressView()
                            Text(stock.symbol)
                        }
                        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    }
                }
                .onDelete(perform: deleteStock)
            }
            .animation(.default, value: stocks)
            .navigationTitle("My Portfolio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NavigationLink(destination: StockDetailView(symbol: "AAPL", name: "Apple", inputSymbol: "AAPL")) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
            .task {
                // Load all quotes when view appears
                for stock in stocks {
                    Task {
                        if let quote = try? await fetchStockQuote(symbol: stock.symbol) {
                            // Store the quote in state
                            await MainActor.run {
                                quotes[stock.symbol] = quote
                            }
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    WatchlistView()
}
