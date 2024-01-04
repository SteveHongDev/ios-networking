//
//  CoinsViewModel.swift
//  NetworkingTutorial
//
//  Created by 홍성범 on 1/1/24.
//

import Foundation

@Observable class CoinsViewModel {
    
    var coins = [Coin]()
    var errorMessage: String?
    
    private let service: CoinServiceProtocol
    
    init(service: CoinServiceProtocol) {
        self.service = service
    }
    
    @MainActor
    func fetchCoins() async {
        do {
            self.coins.append(contentsOf: try await service.fetchCoins())
            print("DEBUG: Did fetch coins")
        } catch {
            guard let error = error as? CoinAPIError else { return }
            self.errorMessage = error.customDescription
        }
    }
    
//    func fetchCoinsWithCompletionHandler() {
//        
//        service.fetchCoinsWithResult { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let coins):
//                    self.coins = coins
//                case .failure(let error):
//                    self.errorMessage = error.localizedDescription
//                }
//            }
//        }
//        
//    }
}
