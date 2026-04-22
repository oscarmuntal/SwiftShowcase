//
//  MockItemsService.swift
//  SwiftShowcaseTests
//
//  Created by Òscar Muntal on 22/4/26.
//

import Foundation
@testable import SwiftShowcase

final class MockItemsService: ItemsServiceProtocol {
    var fetchItemsResult: Result<ItemsPage, Error> = .success(ItemsPage(items: [], total: 0, skip: 0, limit: 20))
    var searchItemsResult: Result<[Item], Error> = .success([])
    var fetchItemsByIdsResult: Result<[Item], Error> = .success([])

    var fetchItemsCalls: [(skip: Int, limit: Int)] = []
    var searchCalls: [String] = []
    var fetchByIdsCalls: [[Int]] = []

    func fetchItems(skip: Int, limit: Int) async throws -> ItemsPage {
        fetchItemsCalls.append((skip: skip, limit: limit))
        return try fetchItemsResult.get()
    }

    func searchItems(query: String) async throws -> [Item] {
        searchCalls.append(query)
        return try searchItemsResult.get()
    }

    func fetchItems(byIds ids: [Int]) async throws -> [Item] {
        fetchByIdsCalls.append(ids)
        return try fetchItemsByIdsResult.get()
    }
}
