//
//  ContentView.swift
//  StockWatcher
//
//  Created by Apeksha Malik on 4/11/25.
//

import SwiftUI
import Charts

struct StockDetailView: View {
    let symbol: String
    var isAddMode: Bool = false

    @StateObject private var viewModel = StockDetailViewModel()
    @EnvironmentObject var watchlistModel: WatchlistModel

    @State private var inputSymbol: String
    @State private var showFormSheet = false
    @State private var showConfirmationSheet = false
    @State private var shares = ""
    @State private var purchasePrice = ""

    // Animations
    @State private var animateChart = false
    @State private var animatePriceInfo = false
    @State private var animateConfirm = false

    init(symbol: String, isAddMode: Bool = false) {
        self.symbol = symbol
        self.isAddMode = isAddMode
        _inputSymbol = State(initialValue: symbol)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Search bar
                    HStack {
                        TextField("Enter stock symbol (e.g., AAPL)", text: $inputSymbol)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.allCharacters)
                            .disableAutocorrection(true)
                        
                        Button("Search") {
                            Task {
                                await viewModel.load(symbol: inputSymbol)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                // Symbol header
                VStack(alignment: .leading, spacing: 4) {
                    Text("$\(viewModel.quote?.symbol ?? inputSymbol)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    if let name = viewModel.quote?.name {
                        Text(name)
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }

                // Chart with animation
                if viewModel.chartData.isEmpty {
                    ProgressView("Loading chart...")
                        .padding()
                } else {
                    withAnimation {
                        Chart(viewModel.chartData) { point in
                            LineMark(
                                x: .value("Date", point.date),
                                y: .value("Price", point.closePrice)
                            )
                            .foregroundStyle(.green)
                            .interpolationMethod(.catmullRom)
                        }
                        .frame(height: 200)
                        .opacity(animateChart ? 1 : 0)
                        .offset(y: animateChart ? 0 : 30)
                        .animation(.easeOut(duration: 0.6), value: animateChart)
                    }
                }

                // Price Info with slide-in animation
                if let q = viewModel.quote {
                    GroupBox(label: Text("Price Info").font(.headline)) {
                        VStack(alignment: .leading, spacing: 8) {
                            metricRow(label: "Open", value: "$\(q.open)")
                            metricRow(label: "Close", value: "$\(q.close)")
                            metricRow(label: "Volume", value: q.volume)
                            metricRow(label: "Change", value: "\(q.change) (\(q.percent_change)%)")
                        }
                        .padding(.horizontal)
                        .opacity(animatePriceInfo ? 1 : 0)
                        .offset(y: animatePriceInfo ? 0 : 20)
                        .animation(.easeInOut(duration: 0.5).delay(0.2), value: animatePriceInfo)
                    }
                } else {
                    ProgressView("Loading metrics...")
                        .padding()
                }

                Spacer()

                if isAddMode {
                    Button(action: {
                        if let open = viewModel.quote?.open {
                            purchasePrice = open
                        } else if let close = viewModel.quote?.close {
                            purchasePrice = close
                        } else {
                            purchasePrice = "0.00"
                        }

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
            await viewModel.load(symbol: symbol)
            animateChart = true
            animatePriceInfo = true
        }

        // Form sheet
        .sheet(isPresented: $showFormSheet) {
            NavigationView {
                Form {
                    Section(header: Text("Purchase Info")) {
                        TextField("Purchase Price", text: $purchasePrice)
                            .keyboardType(.decimalPad)

                        TextField("Number of Shares", text: $shares)
                            .keyboardType(.numberPad)
                    }

                    Button("Confirm Purchase") {
                        watchlistModel.addStock(symbol: inputSymbol,
                                                price: purchasePrice,
                                                change: "+0.00",
                                                changePercent: "0.00%")

                        showFormSheet = false
                        animateConfirm = true
                        showConfirmationSheet = true
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                }
                .navigationTitle("Add to Portfolio")
            }
        }

        .sheet(isPresented: $showConfirmationSheet) {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                    .scaleEffect(animateConfirm ? 1 : 0.5)
                    .opacity(animateConfirm ? 1 : 0)
                    .animation(.spring(), value: animateConfirm)

                Text("✅ \(shares) shares of $\(inputSymbol.uppercased()) added at $\(purchasePrice) each.")
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .padding()

                Button("Close") {
                    showConfirmationSheet = false
                }
                .padding()
            }
            .padding()
            .onAppear {
                animateConfirm = false
                withAnimation {
                    animateConfirm = true
                }
            }
        }
    }

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
}

#Preview {
    StockDetailView(symbol: "AAPL", isAddMode: true)
        .environmentObject(WatchlistModel())
}
