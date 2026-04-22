//
//  HomeViewModel.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 21/4/26.
//

import Combine
import Foundation

@Observable
final class HomeViewModel {
    private let itemsService: ItemsServiceProtocol
    private let favoritesStore: FavoritesStoreProtocol
    private let searchSubject = CurrentValueSubject<String, Never>("")
    private var cancellables = Set<AnyCancellable>()

    var state: ViewState<[Item]> = .idle
    var items: [Item] = []
    var totalItems: Int = 0
    var currentSkip: Int = 0
    let pageSize: Int = 20
    var isLoadingMore: Bool = false
    var searchQuery: String = ""
    var searchResults: [Item] = []
    var showFavoritesFirst: Bool = false
    private var fetchedFavoriteItems: [Item] = []

    var hasMorePages: Bool {
        currentSkip + items.count < totalItems
    }

    var isSearching: Bool {
        !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var displayedItems: [Item] {
        if isSearching { return searchResults }
        guard showFavoritesFirst else { return items }
        let loadedIds = Set(items.map(\.id))
        let missingFavorites = fetchedFavoriteItems.filter { !loadedIds.contains($0.id) }
        return orderedItems(missingFavorites + items)
    }

    init(itemsService: ItemsServiceProtocol, favoritesStore: FavoritesStoreProtocol) {
        self.itemsService = itemsService
        self.favoritesStore = favoritesStore

        searchSubject
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                Task { await self?.runSearch(query: query) }
            }
            .store(in: &cancellables)
    }

    func load() async {
        switch state {
        case .idle, .error, .empty:
            state = .loading
        case .loaded, .loading:
            break
        }
        currentSkip = 0
        items = []
        totalItems = 0

        do {
            let page = try await itemsService.fetchItems(skip: 0, limit: pageSize)
            items = page.items
            totalItems = page.total
            currentSkip = 0
            state = items.isEmpty ? .empty : .loaded(items)
        } catch {
            state = .error(ErrorMessageMapper.message(from: error))
        }
    }

    func loadMore() async {
        guard !isLoadingMore, hasMorePages, case .loaded = state else { return }

        isLoadingMore = true
        defer { isLoadingMore = false }

        let nextSkip = currentSkip + pageSize

        do {
            let page = try await itemsService.fetchItems(skip: nextSkip, limit: pageSize)
            items.append(contentsOf: page.items)
            currentSkip = nextSkip
            totalItems = page.total
            state = .loaded(items)
        } catch {
            print("Load more failed: \(error.localizedDescription)")
        }
    }

    func refresh() async {
        await load()
    }

    func updateSearch(_ query: String) {
        searchQuery = query
        searchSubject.send(query)
    }

    func applyOrderingChange(showFavoritesFirst: Bool) {
        self.showFavoritesFirst = showFavoritesFirst
    }

    func loadFavoriteItems() async {
        let ids = Array(favoritesStore.ids).sorted()
        guard showFavoritesFirst, !ids.isEmpty else {
            fetchedFavoriteItems = []
            return
        }
        do {
            fetchedFavoriteItems = try await itemsService.fetchItems(byIds: ids)
        } catch {
            fetchedFavoriteItems = []
        }
    }

    private func orderedItems(_ source: [Item]) -> [Item] {
        guard showFavoritesFirst else { return source }
        let favorited = source.filter { favoritesStore.contains($0.id) }
        let nonFavorited = source.filter { !favoritesStore.contains($0.id) }
        return favorited + nonFavorited
    }

    private func runSearch(query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            searchResults = []
            return
        }

        do {
            searchResults = try await itemsService.searchItems(query: trimmed)
        } catch {
            searchResults = []
        }
    }
}
