//
//  SearchBar.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 27/4/26.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    // @FocusState programmatically controls whether the text field has keyboard
    // focus, enabling the clear button to dismiss the keyboard on tap.
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField("Search products", text: $text)
                    .focused($isFocused)

                if !text.isEmpty {
                    Button {
                        text = ""
                        isFocused = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            if isFocused {
                Button("Cancel") {
                    text = ""
                    isFocused = false
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
        .animation(.default, value: isFocused)
    }
}

#Preview {
    SearchBar(text: .constant(""))
}

#Preview("With text") {
    SearchBar(text: .constant("iPhone"))
}
