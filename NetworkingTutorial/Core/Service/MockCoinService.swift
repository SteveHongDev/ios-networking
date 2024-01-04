//
//  MockCoinService.swift
//  NetworkingTutorial
//
//  Created by 홍성범 on 1/3/24.
//

import Foundation

class MockCoinService: CoinServiceProtocol {
    
    var mockData: Data?
    var mockError: CoinAPIError?
    
    func fetchCoins() async throws -> [Coin] {
        if let mockError { throw mockError }
        
        do {
            let coins = try JSONDecoder().decode([Coin].self, from: mockData ?? mockCoinsData_marketCapDesc)
            return coins
        } catch {
            throw error as? CoinAPIError ?? .unknownError(error: error)
        }
    }
    
    func fetchCoinDetails(id: String) async throws -> CoinDetails? {
        let description = Description(text: "Number 1 Coin")
        let bitcoinDetails = CoinDetails(id: "bitcoin", symbol: "BTC", name: "Bitcoin", description: description)
        
        return bitcoinDetails
    }
    
}
