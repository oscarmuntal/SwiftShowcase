//
//  NavigationState.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 21/4/26.
//

import SwiftUI

/// Shared navigation state injected into the environment.
/// Each tab owns its own `NavigationPath` so pushes are independent.
@Observable
final class NavigationState {
    var homePath = NavigationPath()
    var favoritesPath = NavigationPath()
}
