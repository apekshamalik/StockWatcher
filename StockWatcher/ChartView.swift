//
//  ChartView.swift
//  StockWatcher
//
//  Created by Vidyut Veedgav on 4/14/25.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @Binding var stockDetailModel: StockDetailModel
    
    var body: some View {
        Chart(stockDetailModel.chartData) { point in
            LineMark(
                x: .value("Date", point.date),
                y: .value("Price", point.closePrice)
            )
            .foregroundStyle(.green)
            .interpolationMethod(.catmullRom)
        }
        .frame(height: 200)
    }
}

#Preview {
    ChartView(stockDetailModel: .constant(StockDetailModel()))
}
