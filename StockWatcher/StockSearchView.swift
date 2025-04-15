//
//  StockSearchView.swift
//  StockWatcher
//
//  Created by Vidyut Veedgav on 4/15/25.
//

import SwiftUI

struct StockSearchView: View {
    
    @Binding var inputSymbol: String
    @Binding var stockDetailModel: StockDetailModel
    @State var scale = 1.0
    
    var body: some View {
        HStack {
            TextField("Enter stock symbol (e.g., AAPL)", text: $inputSymbol)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.allCharacters)
                .disableAutocorrection(true)
                .scaleEffect(scale, anchor: .leading)
            
            Button("Search") {
                if inputSymbol.isEmpty {
                    withAnimation(.spring) {
                        scale = 2.0
                    } completion: {
                        withAnimation {
                            scale = 1.0
                        }
                    }
                }
                Task {
                    await stockDetailModel.load(symbol: inputSymbol)
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    StockSearchView(inputSymbol: .constant(""), stockDetailModel: .constant(StockDetailModel()))
}
