//
//  ConfirmationView.swift
//  StockWatcher
//
//  Created by Vidyut Veedgav on 4/15/25.
//

import SwiftUI

struct ConfirmationView: View {
    @Binding var showFormSheet: Bool
    @Binding var purchasePrice: String
    @Binding var inputSymbol: String
    @Binding var showConfirmationSheet: Bool
    @Binding var repeatedStock: Bool

    var change: String
    var changePercent: String
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            Button("Are you sure?") {
                guard !repeatedStock else {
                    showFormSheet = false
                    showConfirmationSheet = true
                    return
                }
                
                let newStock = WatchlistStock(
                    symbol: inputSymbol.uppercased(),
                    price: purchasePrice,
                    change: change,
                    changePercent: changePercent
                )
                
                modelContext.insert(newStock)
                showFormSheet = false
                showConfirmationSheet = true
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .padding()
        }
        .navigationTitle("Add to Portfolio")
    }
}


#Preview {
    ConfirmationView(showFormSheet: .constant(true), purchasePrice: .constant(""), inputSymbol: .constant(""), showConfirmationSheet: .constant(true), repeatedStock: .constant(false), change: "", changePercent: "")
}
