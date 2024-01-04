//
//  Coin.swift
//  NetworkingTutorial
//
//  Created by 홍성범 on 1/2/24.
//

import Foundation

struct Coin: Decodable, Identifiable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let currentPrice: Double
    let marketCapRank: Int
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
    }
}
