//
//  FavoritesStoreTests.swift
//  SwiftShowcaseTests
//
//  Created by Òscar Muntal on 23/4/26.
//

import XCTest
@testable import SwiftShowcase

@MainActor
final class FavoritesStoreTests: XCTestCase {
    private let suiteName = "com.swiftshowcase.tests.favorites"
    private let key = StorageKeys.favoriteItemIDs
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        super.tearDown()
    }

    func test_addAndContains() {
        let store = FavoritesStore(defaults: defaults)

        store.add(1)

        XCTAssertTrue(store.contains(1))
        XCTAssertFalse(store.contains(2))
    }

    func test_remove() {
        let store = FavoritesStore(defaults: defaults)
        store.add(1)

        store.remove(1)

        XCTAssertFalse(store.contains(1))
    }

    func test_persistsAcrossInstances() {
        let first = FavoritesStore(defaults: defaults)
        first.add(5)
        first.add(10)

        let second = FavoritesStore(defaults: defaults)

        XCTAssertTrue(second.contains(5))
        XCTAssertTrue(second.contains(10))
        XCTAssertEqual(second.ids, [5, 10])
    }

    func test_corruptedDataResetsToEmpty() {
        defaults.set(Data("not json".utf8), forKey: key)

        let store = FavoritesStore(defaults: defaults)

        XCTAssertTrue(store.ids.isEmpty)
        XCTAssertNil(defaults.data(forKey: key))
    }
}
