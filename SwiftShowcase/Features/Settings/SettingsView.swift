//
//  SettingsView.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 22/4/26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(StorageKeys.appearanceMode) private var appearanceModeRaw: String = AppearanceMode.system.rawValue
    @AppStorage(StorageKeys.showFavoritesFirst) private var showFavoritesFirst = false
    @State private var viewModel = SettingsViewModel()

    private var appearanceMode: Binding<AppearanceMode> {
        Binding(
            get: { AppearanceMode(rawValue: appearanceModeRaw) ?? .system },
            set: { appearanceModeRaw = $0.rawValue }
        )
    }

    var body: some View {
        Form {
            Section("Appearance") {
                Picker("Mode", selection: appearanceMode) {
                    ForEach(AppearanceMode.allCases) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
                .pickerStyle(.menu)
            }

            Section("Behavior") {
                Toggle("Show favorites first", isOn: $showFavoritesFirst)
            }

            Section("Onboarding") {
                Button("Show onboarding again") {
                    viewModel.resetOnboarding()
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
