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
    @AppStorage(StorageKeys.appearanceMode) private var appearanceModeRaw: String = AppearanceMode.system.rawValue
    @SceneStorage(StorageKeys.selectedTab) private var savedTab: String = Tab.home.rawValue

    var body: some View {
        @Bindable var navState = navigationState
        let appearanceMode = AppearanceMode(rawValue: appearanceModeRaw) ?? .system

        TabView(selection: $navState.selectedTab) {
            NavigationStack(path: $navState.homePath) {
                HomeView(itemsService: itemsService, favoritesStore: favoritesStore)
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(Tab.home)

            NavigationStack(path: $navState.favoritesPath) {
                FavoritesView(itemsService: itemsService, favoritesStore: favoritesStore)
            }
            .tabItem {
                Label("Favorites", systemImage: "star.fill")
            }
            .tag(Tab.favorites)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(Tab.settings)
        }
        .task {
            navigationState.selectedTab = Tab(rawValue: savedTab) ?? .home
        }
        .onChange(of: navigationState.selectedTab) { _, newValue in
            savedTab = newValue.rawValue
        }
        .preferredColorScheme(appearanceMode.colorScheme)
        #if DEBUG
        .overlay(alignment: .top) {
            Text("DEBUG")
                .font(.caption2)
                .bold()
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Capsule().fill(.red))
                .padding(.top, 4)
        }
        #endif
    }
}
