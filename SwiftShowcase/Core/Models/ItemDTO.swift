//
//  ItemDTO.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 20/4/26.
//

import Foundation

nonisolated struct ItemDTO: Decodable, Sendable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let thumbnail: String
    let images: [String]
    let rating: Double
    let stock: Int
    let brand: String?
}

nonisolated struct ProductsResponseDTO: Decodable, Sendable {
    let products: [ItemDTO]
    let total: Int
    let skip: Int
    let limit: Int
}
