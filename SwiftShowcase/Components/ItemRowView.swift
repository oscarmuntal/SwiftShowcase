//
//  ItemRowView.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 21/4/26.
//

import SwiftUI

struct ItemRowView: View {
    let item: Item

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: item.thumbnailURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color(.systemGray5)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundStyle(.secondary)
                    }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(item.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(String(format: "$%.2f", item.price))
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    ItemRowView(item: .preview)
        .padding()
}
