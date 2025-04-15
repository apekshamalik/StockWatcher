//
//  TitleView.swift
//  StockWatcher
//
//  Created by Vidyut Veedgav on 4/14/25.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
               
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(Color.blue)
                
                VStack(spacing: 10) {
                    Text("Stock Portfolio Tracker")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white)
                    
                    Text("Monitor your stocks in real-time. Watch for exciting activity and make informed trading decisions!")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                }

                NavigationLink(destination: WatchlistView()) {
                    Text("Start Researching")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color.green, Color.blue], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    TitleView()
}
