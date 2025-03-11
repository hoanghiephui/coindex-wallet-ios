//
//  MainSearchView.swift
//  Production
//
//  Created by Hiep Nguyen on 11/3/25.
//  Copyright © 2025 CoinDex Wallet. All rights reserved.
//

import MarketKit
import SwiftUI
import ThemeKit

struct MainSearchView: View {
    @StateObject var searchViewModel: MarketSearchViewModel
    @StateObject var watchlistViewModel: WatchlistViewModel
    @StateObject var sectorsViewModel: MarketSectorsViewModel
    
    @FocusState var searchFocused: Bool
    @State private var advancedSearchPresented = false
    
    init() {
        _searchViewModel = StateObject(wrappedValue: MarketSearchViewModel())
        _watchlistViewModel = StateObject(wrappedValue: WatchlistViewModel(page: .markets, section: .coins))
        _sectorsViewModel = StateObject(wrappedValue: MarketSectorsViewModel())
    }
    
    var body: some View {
        ThemeView {
            VStack(spacing: 0) {
                SearchBarWithCancel(text: $searchViewModel.searchText, prompt: "placeholder.search".localized, focused: $searchFocused)

                ZStack {
                    VStack(spacing: 0) {
                        MarketSectorsView(viewModel: sectorsViewModel)
                    }.onFirstAppear {
                        sectorsViewModel.loadTop()
                    }
                    if searchFocused {
                        MarketSearchView(viewModel: searchViewModel, watchlistViewModel: watchlistViewModel)
                            .onFirstAppear { stat(page: .markets, event: .open(page: .marketSearch)) }
                    }
                }
            }
        }
    }
}

#Preview {
    MainSearchView()
}
