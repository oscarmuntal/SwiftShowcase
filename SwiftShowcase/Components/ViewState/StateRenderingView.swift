//
//  StateRenderingView.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 22/4/26.
//

import SwiftUI

struct StateRenderingView<T, Content: View>: View {
    let state: ViewState<T>
    let emptyTitle: String
    let emptyMessage: String
    let emptySystemImage: String
    let retry: () -> Void
    @ViewBuilder let content: (T) -> Content

    var body: some View {
        switch state {
        case .idle, .loading:
            LoadingView()
        case .error(let message):
            ErrorView(message: message, retry: retry)
        case .empty:
            EmptyStateView(title: emptyTitle, message: emptyMessage, systemImage: emptySystemImage)
        case .loaded(let value):
            content(value)
        }
    }
}
