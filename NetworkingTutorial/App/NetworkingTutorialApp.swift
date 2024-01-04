//
//  NetworkingTutorialApp.swift
//  NetworkingTutorial
//
//  Created by 홍성범 on 1/1/24.
//

import SwiftUI

@main
struct NetworkingTutorialApp: App {
//    @State var viewModel = CoinsViewModel(service: CoinDataService())
    
    var body: some Scene {
        WindowGroup {
            ContentView(service: CoinDataService())
            
//            ContentView()
//                .environment(viewModel)
        }
    }
}
