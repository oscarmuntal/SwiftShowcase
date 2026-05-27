//
//  ItemsServiceProtocol.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 20/4/26.
//

import Foundation

protocol ItemsServiceProtocol: Sendable {
    func fetchItems(skip: Int, limit: Int) async throws -> ItemsPage
    func searchItems(query: String) async throws -> [Item]
    func fetchItems(byIds ids: [Int]) async throws -> [Item]
}
