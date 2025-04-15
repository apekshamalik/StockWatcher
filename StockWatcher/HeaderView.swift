//
//  HeaderView.swift
//  StockWatcher
//
//  Created by Vidyut Veedgav on 4/15/25.
//

import SwiftUI

struct HeaderView: View {
    
    @Binding var stockDetailModel: StockDetailModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(stockDetailModel.quote?.symbol ?? "Cannot find symbol")")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)

            if let name = stockDetailModel.quote?.name {
                Text(name)
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    HeaderView(stockDetailModel: .constant(StockDetailModel()))
}
