//
//  FavoritesStore.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 21/4/26.
//

import Foundation

@Observable
final class FavoritesStore: FavoritesStoreProtocol {
    private static let key = "favorites.itemIDs.v1"
    private(set) var ids: Set<Int>
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: Self.key) {
            do {
                let decoded = try JSONDecoder().decode([Int].self, from: data)
                self.ids = Set(decoded)
            } catch {
                print("FavoritesStore: corrupted UserDefaults data, resetting. Error: \(error)")
                defaults.removeObject(forKey: Self.key)
                self.ids = []
            }
        } else {
            self.ids = []
        }
    }

    func contains(_ id: Int) -> Bool {
        ids.contains(id)
    }

    func add(_ id: Int) {
        ids.insert(id)
        persist()
    }

    func remove(_ id: Int) {
        ids.remove(id)
        persist()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(Array(ids)) {
            defaults.set(data, forKey: Self.key)
        }
    }
}
