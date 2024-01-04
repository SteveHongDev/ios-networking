//
//  CoinDetailsViewModel.swift
//  NetworkingTutorial
//
//  Created by 홍성범 on 1/3/24.
//

import Foundation

@Observable class CoinDetailsViewModel {
    private let service: CoinServiceProtocol
    private let coinId: String
    
    var coinDetails: CoinDetails?
    
    init(coinId: String, service: CoinServiceProtocol) {
        self.coinId = coinId
        self.service = service
    }
    
    @MainActor
    func fetchCoinDetails() async {
        do {
            self.coinDetails = try await service.fetchCoinDetails(id: coinId)
        } catch {
            print("DEBUG: Error \(error.localizedDescription)")
        }
    }
}
