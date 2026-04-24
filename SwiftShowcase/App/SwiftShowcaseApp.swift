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
    @AppStorage(StorageKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    let itemsService: ItemsServiceProtocol = ItemsService()

    var body: some Scene {
        WindowGroup {
            RootTabsView(
                itemsService: itemsService,
                favoritesStore: favoritesStore
            )
            .environment(navigationState)
            .fullScreenCover(isPresented: Binding(
                get: { !hasCompletedOnboarding },
                set: { hasCompletedOnboarding = !$0 }
            )) {
                OnboardingView(itemsService: itemsService)
                    .environment(navigationState)
            }
        }
    }
}
