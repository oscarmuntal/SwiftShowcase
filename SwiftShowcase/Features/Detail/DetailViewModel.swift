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
        get { favoritesStore.contains(item.id) }
        set { newValue ? favoritesStore.add(item.id) : favoritesStore.remove(item.id) }
    }

    init(item: Item, favoritesStore: FavoritesStoreProtocol) {
        self.item = item
        self.favoritesStore = favoritesStore
    }
}
