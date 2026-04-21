//
//  FavoritesStoreProtocol.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 21/4/26.
//

import Foundation

protocol FavoritesStoreProtocol: AnyObject {
    var ids: Set<Int> { get }
    func contains(_ id: Int) -> Bool
    func add(_ id: Int)
    func remove(_ id: Int)
}
