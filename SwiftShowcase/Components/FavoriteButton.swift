//
//  FavoriteButton.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 27/4/26.
//

import SwiftUI

struct FavoriteButton: View {
    // @Binding enables two-way communication:
    // this component reads and writes a Bool owned by its parent without knowing how the value is stored
    @Binding var isFavorite: Bool

    var body: some View {
        Button {
            isFavorite.toggle()
        } label: {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .foregroundStyle(isFavorite ? .yellow : .secondary)
        }
    }
}

#Preview() {
    VStack(spacing: 16) {
        HStack {
            Text("Favorited")
            FavoriteButton(isFavorite: .constant(true))
        }
        HStack {
            Text("Not Favorited")
            FavoriteButton(isFavorite: .constant(false))
        }
    }
}
