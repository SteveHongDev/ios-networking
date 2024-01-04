//
//  CoinDetailsView.swift
//  NetworkingTutorial
//
//  Created by 홍성범 on 1/3/24.
//

import SwiftUI

struct CoinDetailsView: View {
    let coin: Coin
//    @Environment(CoinsViewModel.self) var viewModel: CoinsViewModel
    
    var viewModel: CoinDetailsViewModel
    
    init(coin: Coin, service: CoinServiceProtocol) {
        self.coin = coin
        self.viewModel = CoinDetailsViewModel(coinId: coin.id, service: service)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let details = viewModel.coinDetails {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(details.name)
                                .fontWeight(.semibold)
                                .font(.subheadline)
                            
                            Text(details.symbol.uppercased())
                                .font(.footnote)
                                .padding(.bottom)
                        }
                        
                        Spacer()
                        
                        CoinImageView(url: coin.image)
                            .frame(width: 64, height: 64)
                    }
                    
                    Text(details.description.text)
                }
            }
            .task {
                await viewModel.fetchCoinDetails()
            }
            .padding()
        }
    }
}
