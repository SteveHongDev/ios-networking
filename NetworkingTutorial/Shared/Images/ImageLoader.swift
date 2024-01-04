//
//  ImageLoader.swift
//  NetworkingTutorial
//
//  Created by 홍성범 on 1/4/24.
//

import SwiftUI

@Observable class ImageLoader {
    var image: Image?
    
    private let urlString: String
    
    init(url: String) {
        self.urlString = url
        Task { await loadImage() }
    }
    
    @MainActor
    private func loadImage() async {
        if let cached = ImageCache.shared.get(forKey: urlString) {
            self.image = Image(uiImage: cached)
            return
        }
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("DEBUG: Did receive data from endpoint...")
            guard let uiImage = UIImage(data: data) else { return }
            ImageCache.shared.set(uiImage, forKey: urlString)
            self.image = Image(uiImage: uiImage)
        } catch {
            print("DEBUG: Failed to fetch image with error \(error)")
        }
    }
}
