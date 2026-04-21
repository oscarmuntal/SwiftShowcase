//
//  ItemsPage.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 20/4/26.
//

import Foundation

/// Domain wrapper for a paginated response from the items API.
/// The service layer maps `ProductsResponseDTO` into this type.
nonisolated struct ItemsPage: Equatable, Sendable {
    let items: [Item]
    let total: Int
    let skip: Int
    let limit: Int

    var hasMore: Bool { skip + items.count < total }
}
