//
//  CoinImageView.swift
//  NetworkingTutorial
//
//  Created by 홍성범 on 1/4/24.
//

import SwiftUI

struct CoinImageView: View {
    var imageLoader: ImageLoader
    
    init(url: String) {
        self.imageLoader = ImageLoader(url: url)
    }
    var body: some View {
        if let image = imageLoader.image {
            image
                .resizable()
        }
    }
}

#Preview {
    CoinImageView(url: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400")
}
