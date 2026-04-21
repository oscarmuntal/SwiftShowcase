//
//  DetailViewModel.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 21/4/26.
//

import Foundation

@Observable
final class DetailViewModel {
    let item: Item
    private let favoritesStore: FavoritesStoreProtocol

    var isFavorite: Bool {
        favoritesStore.contains(item.id)
    }

    init(item: Item, favoritesStore: FavoritesStoreProtocol) {
        self.item = item
        self.favoritesStore = favoritesStore
    }

    func toggleFavorite() {
        if isFavorite {
            favoritesStore.remove(item.id)
        } else {
            favoritesStore.add(item.id)
        }
    }
}
