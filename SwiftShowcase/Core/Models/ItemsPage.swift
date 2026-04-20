import Foundation

/// Domain wrapper for a paginated response from the items API.
/// The service layer maps `ProductsResponseDTO` into this type.
struct ItemsPage: Equatable {
    let items: [Item]
    let total: Int
    let skip: Int
    let limit: Int

    var hasMore: Bool { skip + items.count < total }
}
