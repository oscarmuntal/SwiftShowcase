//
//  FavoritesView.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 22/4/26.
//

import SwiftUI

struct FavoritesView: View {
    let favoritesStore: FavoritesStoreProtocol
    @State private var viewModel: FavoritesViewModel

    init(itemsService: ItemsServiceProtocol, favoritesStore: FavoritesStoreProtocol) {
        self.favoritesStore = favoritesStore
        _viewModel = State(initialValue: FavoritesViewModel(
            itemsService: itemsService,
            favoritesStore: favoritesStore
        ))
    }

    var body: some View {
        StateRenderingView(
            state: viewModel.state,
            emptyTitle: "No favorites yet",
            emptyMessage: "Tap the star on any product to add it here.",
            emptySystemImage: "star",
            retry: { Task { await viewModel.load() } }
        ) { items in
            List {
                ForEach(items) { item in
                    NavigationLink(value: item) {
                        ItemRowView(item: item)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            Task { await viewModel.remove(item) }
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .navigationDestination(for: Item.self) { item in
            DetailView(item: item, favoritesStore: favoritesStore)
        }
        .navigationTitle("Favorites")
        .task { await viewModel.load() }
        .onAppear { Task { await viewModel.load() } }
    }
}
