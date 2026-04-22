//
//  FavoritesViewModel.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 22/4/26.
//

import Foundation

@Observable
final class FavoritesViewModel {
    private let itemsService: ItemsServiceProtocol
    private let favoritesStore: FavoritesStoreProtocol

    var state: ViewState<[Item]> = .idle

    init(itemsService: ItemsServiceProtocol, favoritesStore: FavoritesStoreProtocol) {
        self.itemsService = itemsService
        self.favoritesStore = favoritesStore
    }

    func load() async {
        let ids = Array(favoritesStore.ids).sorted()
        guard !ids.isEmpty else {
            state = .empty
            return
        }

        state = .loading

        do {
            let items = try await itemsService.fetchItems(byIds: ids)
            if items.isEmpty {
                state = .error("Could not load your favorites. Please try again.")
            } else {
                state = .loaded(items)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func remove(_ item: Item) async {
        favoritesStore.remove(item.id)
        if favoritesStore.ids.isEmpty {
            state = .empty
        } else {
            await load()
        }
    }
}
