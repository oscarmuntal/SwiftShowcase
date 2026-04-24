//
//  HomeView.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 21/4/26.
//

import SwiftUI

struct HomeView: View {
    let favoritesStore: FavoritesStoreProtocol
    @State private var viewModel: HomeViewModel
    @State private var searchText = ""
    @AppStorage(StorageKeys.showFavoritesFirst) private var showFavoritesFirst = false

    init(itemsService: ItemsServiceProtocol, favoritesStore: FavoritesStoreProtocol) {
        self.favoritesStore = favoritesStore
        _viewModel = State(initialValue: HomeViewModel(itemsService: itemsService, favoritesStore: favoritesStore))
    }

    var body: some View {
        StateRenderingView(
            state: viewModel.state,
            emptyTitle: "No products",
            emptyMessage: "Try refreshing.",
            retry: { Task { await viewModel.load() } }
        ) { _ in
            let displayed = viewModel.displayedItems
            if viewModel.isSearching, displayed.isEmpty {
                EmptyStateView(
                    title: "No results",
                    message: "No products match \"\(searchText)\".",
                    systemImage: "magnifyingglass"
                )
            } else {
                List {
                    ForEach(displayed) { item in
                        NavigationLink(value: item) {
                            ItemRowView(item: item)
                        }
                        .onAppear {
                            if !viewModel.isSearching, item.id == displayed.last?.id {
                                Task { await viewModel.loadMore() }
                            }
                        }
                    }
                    if !viewModel.isSearching, viewModel.isLoadingMore {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
                .refreshable { await viewModel.refresh() }
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { _, newValue in
            viewModel.updateSearch(newValue)
        }
        .navigationDestination(for: Item.self) { item in
            DetailView(item: item, favoritesStore: favoritesStore)
        }
        .navigationTitle("Home")
        .task {
            viewModel.applyOrderingChange(showFavoritesFirst: showFavoritesFirst)
            if case .idle = viewModel.state {
                await viewModel.load()
            }
            await viewModel.loadFavoriteItems()
        }
        .onChange(of: showFavoritesFirst) { _, newValue in
            viewModel.applyOrderingChange(showFavoritesFirst: newValue)
            Task { await viewModel.loadFavoriteItems() }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(itemsService: PreviewItemsService(), favoritesStore: FavoritesStore())
    }
}

private struct PreviewItemsService: ItemsServiceProtocol {
    func fetchItems(skip: Int, limit: Int) async throws -> ItemsPage {
        ItemsPage(items: [.preview], total: 1, skip: 0, limit: 20)
    }

    func searchItems(query: String) async throws -> [Item] {
        [.preview]
    }

    func fetchItems(byIds ids: [Int]) async throws -> [Item] {
        [.preview]
    }
}

