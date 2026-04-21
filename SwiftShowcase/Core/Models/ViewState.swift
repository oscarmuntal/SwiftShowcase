//
//  ViewState.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 20/4/26.
//

import Foundation

/// Represents the async lifecycle of a data-loading operation.
/// Views switch over this enum to show the appropriate UI for each phase.
enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case empty
    case error(String)
}

extension ViewState: Equatable where T: Equatable {}
