//
//  ContentView.swift
//  NetworkingTutorial
//
//  Created by 홍성범 on 1/1/24.
//

import SwiftUI

struct ContentView: View {
    private let service: CoinServiceProtocol
    @State private var viewModel: CoinsViewModel
//    @Environment(CoinsViewModel.self) private var viewModel: CoinsViewModel
    
    init(service: CoinServiceProtocol) {
        self.service = service
        self._viewModel = State(wrappedValue: CoinsViewModel(service: service))
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.coins) { coin in
                    NavigationLink(value: coin) {
                        HStack(spacing: 12) {
                            Text("\(coin.marketCapRank)")
                                .foregroundStyle(.gray)
                            
                            CoinImageView(url: coin.image)
                                .frame(width: 32, height: 32)
                            
                            VStack(alignment: .leading) {
                                Text(coin.name)
                                    .fontWeight(.semibold)
                                
                                Text(coin.symbol.uppercased())
                            }
                        }
                        .onAppear {
                            if coin == viewModel.coins.last {
                                Task { await viewModel.fetchCoins() }
                            }
                        }
                        .font(.footnote)
                    }
                }
            }
            .navigationDestination(for: Coin.self, destination: { coin in
                CoinDetailsView(coin: coin, service: service)
            })
        }
        .task {
            await viewModel.fetchCoins()
        }
        .overlay {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    ContentView(service: MockCoinService())
}
