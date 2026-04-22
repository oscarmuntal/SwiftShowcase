//
//  MockFavoritesStore.swift
//  SwiftShowcaseTests
//
//  Created by Òscar Muntal on 22/4/26.
//

import Foundation
@testable import SwiftShowcase

final class MockFavoritesStore: FavoritesStoreProtocol {
    private(set) var ids: Set<Int> = []

    func contains(_ id: Int) -> Bool {
        ids.contains(id)
    }

    func add(_ id: Int) {
        ids.insert(id)
    }

    func remove(_ id: Int) {
        ids.remove(id)
    }
}
