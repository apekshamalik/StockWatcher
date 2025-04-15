//
//  WatchListItemView.swift
//  StockWatcher
//
//  Created by Vidyut Veedgav on 4/14/25.
//

import SwiftUI

struct StockRowView: View {
    
    var stock: WatchlistStock
    
    var body: some View {
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
        .padding()
    }
}

#Preview {
    StockRowView(stock: WatchlistStock(symbol: "AAPL", price: "123.67", change: "+3.95", changePercent: "+0.12%"))
}
