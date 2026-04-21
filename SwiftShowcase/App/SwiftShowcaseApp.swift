//
//  SwiftShowcaseApp.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 20/4/26.
//

import SwiftUI

@main
struct SwiftShowcaseApp: App {
    @State private var navigationState = NavigationState()
    @State private var favoritesStore = FavoritesStore()
    let itemsService: ItemsServiceProtocol = ItemsService()

    var body: some Scene {
        WindowGroup {
            RootTabsView(
                itemsService: itemsService,
                favoritesStore: favoritesStore
            )
            .environment(navigationState)
        }
    }
}
