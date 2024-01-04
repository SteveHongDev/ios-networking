//
//  CoinDataService.swift
//  NetworkingTutorial
//
//  Created by 홍성범 on 1/2/24.
//

import Foundation

protocol CoinServiceProtocol {
    func fetchCoins() async throws -> [Coin]
    func fetchCoinDetails(id: String) async throws -> CoinDetails?
}

class CoinDataService: HTTPDataDownloader, CoinServiceProtocol {
    
    private var page = 0
    private let fetchLimit = 20
    
    func fetchCoins() async throws -> [Coin] {
        page += 1
        
        guard let url = allCoinsUrl else { throw CoinAPIError.requestFailed(description: "Invalid URL") }
        return try await fetchData(as: [Coin].self, url: url)
    }
    
    func fetchCoinDetails(id: String) async throws -> CoinDetails? {
        if let cache = CoinDetailsCache.shared.get(forKey: id) {
            print("DEBUG: Got details from cache")
            return cache
        }
        guard let url = coinDetailsUrl(id: id) else { throw CoinAPIError.requestFailed(description: "Invalid URL") }
        
        let details = try await fetchData(as: CoinDetails.self, url: url)
        
        print("DEBUG: Got details from API")
        CoinDetailsCache.shared.set(details, forKey: id)
        
        return details
    }
    
    private var baseUrlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coingecko.com"
        components.path = "/api/v3/coins/"
        
        return components
    }
    
    private var allCoinsUrl: URL? {
        var components = baseUrlComponents
        components.path += "markets"
        
        components.queryItems = [
            .init(name: "vs_currency", value: "usd"),
            .init(name: "order", value: "market_cap_desc"),
            .init(name: "per_page", value: "\(fetchLimit)"),
            .init(name: "page", value: "\(page)"),
            .init(name: "sparkline", value: "false"),
            .init(name: "price_change_percentage", value: "24h"),
            .init(name: "locale", value: "en")
        ]
        
        return components.url
    }
    
    private func coinDetailsUrl(id: String) -> URL? {
        var components = baseUrlComponents
        components.path += id
        
        components.queryItems = [
            .init(name: "localization", value: "false")
        ]
        
        return components.url
    }
}

// MARK: - Completion Handlers

extension CoinDataService {
    func fetchCoinsWithResult(completion: @escaping (Result<[Coin], CoinAPIError>) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=30&page=1&sparkline=false&price_change_percentage=24h&locale=en"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Request failed")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                print("DEBUG: Failed to decode: \(error.localizedDescription)")
                completion(.failure(.jsonParsingFailure))
            }
        }.resume()
    }
        
    func fetchPrice(coin: String, completion: @escaping (Int) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin.lowercased())&vs_currencies=krw"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DEBUG: Failed with error (\(error.localizedDescription))")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Bad http response")
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                print("Failed to fetch with status code \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String : Any] else { return }
            
            guard let value = jsonObject[coin] as? [String : Int] else {
                print("Failed to parse value")
                return
            }
            guard let price = value["krw"] else { return }
            
            print("DEBUG: Price in service is \(price)")
            completion(price)
        }.resume()
        
    }
}
