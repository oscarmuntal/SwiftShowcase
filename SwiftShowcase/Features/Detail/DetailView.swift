//
//  DetailView.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 21/4/26.
//

import SwiftUI

struct DetailView: View {
    let item: Item
    @State private var viewModel: DetailViewModel
    @State private var showInfoSheet = false

    init(item: Item, favoritesStore: FavoritesStoreProtocol) {
        self.item = item
        _viewModel = State(initialValue: DetailViewModel(item: item, favoritesStore: favoritesStore))
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: item.imageURLs.first ?? item.thumbnailURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color(.systemGray5)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                        }
                }
                .frame(height: 250)
                .frame(maxWidth: .infinity)
                .clipped()

                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title)
                        .font(.title2)

                    Text(item.category)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(String(format: "$%.2f", item.price))
                        .font(.title)
                        .bold()

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", item.rating))
                    }
                    .font(.subheadline)

                    Text("\(item.stock) in stock")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(item.description)
                        .font(.body)
                        .padding(.top, 4)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                FavoriteButton(isFavorite: $viewModel.isFavorite)
                Button {
                    showInfoSheet = true
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .sheet(isPresented: $showInfoSheet) {
            InfoSheetView(item: item)
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(item: .preview, favoritesStore: FavoritesStore())
    }
}
