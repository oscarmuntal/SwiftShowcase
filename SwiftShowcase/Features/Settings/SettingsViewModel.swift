//
//  SettingsViewModel.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 22/4/26.
//

import Foundation

/// Settings that are simple toggles or pickers (appearance mode, show favorites first)
/// use `@AppStorage` directly in the View, bypassing the ViewModel.
/// The ViewModel only handles actions that involve logic beyond a single write.
@Observable
final class SettingsViewModel {
    func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
    }
}
