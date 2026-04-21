//
//  InfoSheetView.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 21/4/26.
//

import SwiftUI

struct InfoSheetView: View {
    let item: Item
    @State private var showFullDescription = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Details") {
                    LabeledContent("Title", value: item.title)
                    if let brand = item.brand {
                        LabeledContent("Brand", value: brand)
                    }
                    LabeledContent("Category", value: item.category)
                    LabeledContent("Price", value: String(format: "$%.2f", item.price))
                    LabeledContent("Rating", value: String(format: "%.1f / 5", item.rating))
                    LabeledContent("Stock", value: "\(item.stock)")
                }

                Section("Description") {
                    Text(item.description)
                        .lineLimit(showFullDescription ? nil : 2)
                    Button(showFullDescription ? "Show less" : "Show more") {
                        showFullDescription.toggle()
                    }
                    .font(.caption)
                }
            }
            .navigationTitle("Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    InfoSheetView(item: .preview)
}
