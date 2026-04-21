//
//  HomeView.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 21/4/26.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init(itemsService: ItemsServiceProtocol) {
        _viewModel = State(initialValue: HomeViewModel(itemsService: itemsService))
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                LoadingView()
            case .error(let message):
                ErrorView(message: message, retry: {
                    Task { await viewModel.load() }
                })
            case .empty:
                EmptyStateView(title: "No products", message: "Try refreshing.")
            case .loaded(let items):
                List {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            ItemRowView(item: item)
                        }
                        .onAppear {
                            if item.id == items.last?.id {
                                Task { await viewModel.loadMore() }
                            }
                        }
                    }
                    if viewModel.isLoadingMore {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
                .refreshable { await viewModel.refresh() }
            }
        }
        .navigationTitle("Home")
        .task {
            if case .idle = viewModel.state {
                await viewModel.load()
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(itemsService: PreviewItemsService())
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

