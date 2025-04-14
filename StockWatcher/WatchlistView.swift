import SwiftUI

struct WatchlistStock: Identifiable {
    let id = UUID()
    let symbol: String
    let price: String
    let change: String
    let changePercent: String
}

struct WatchlistView: View {
    @EnvironmentObject var watchlistModel: WatchlistModel

    var body: some View {
        NavigationView {
            VStack {
                Text("My Portfolio")
                    .font(.largeTitle)
                    .fontWeight(.regular)
                    .bold()
                    .padding(.top)

                List {
                    ForEach(watchlistModel.stocks) { stock in
                        NavigationLink(destination: StockDetailView(symbol: stock.symbol)) {
                            HStack {
                                Text(stock.symbol)
                                    .font(.headline)
                                    .frame(width: 60, alignment: .leading)

                                Spacer()

                                VStack(alignment: .trailing) {
                                    Text("$\(stock.price)")
                                    Text("\(stock.change) (\(stock.changePercent))")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(14)
                            .background(Color.black)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.white)
            }
            .background(Color.white)
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NavigationLink(destination: StockDetailView(symbol: "AAPL", isAddMode: true)
                    .environmentObject(watchlistModel)) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
        }
    }
}

#Preview {
    WatchlistView()
        .environmentObject(WatchlistModel())
}
