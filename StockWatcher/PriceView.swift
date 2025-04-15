//
//  PriceView.swift
//  StockWatcher
//
//  Created by Vidyut Veedgav on 4/15/25.
//

import SwiftUI

struct PriceView: View {
    
    @Binding var stockDetailModel: StockDetailModel
    
    func metricRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.black)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
    }
    
    var body: some View {
        if let q = stockDetailModel.quote {
            GroupBox(label: Text("Price Info").font(.headline)) {
                VStack(alignment: .leading, spacing: 8) {
                    metricRow(label: "Open", value: "$\(q.open)")
                    metricRow(label: "Close", value: "$\(q.close)")
                    metricRow(label: "Volume", value: q.volume)
                    metricRow(label: "Change", value: "\(q.change) (\(q.percent_change)%)")
                }
                .padding(.horizontal)
            }
        } else {
            ProgressView("Loading metrics...")
                .padding()
        }
    }
}

#Preview {
    PriceView(stockDetailModel: .constant(StockDetailModel()))
}
