//
//  RootTabsView.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 21/4/26.
//

import SwiftUI

struct RootTabsView: View {
    let itemsService: ItemsServiceProtocol
    let favoritesStore: FavoritesStoreProtocol

    @Environment(NavigationState.self) var navigationState

    var body: some View {
        @Bindable var navState = navigationState

        TabView {
            NavigationStack(path: $navState.homePath) {
                Text("Home")
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationStack(path: $navState.favoritesPath) {
                Text("Favorites")
            }
            .tabItem {
                Label("Favorites", systemImage: "star.fill")
            }

            NavigationStack {
                Text("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}
