import Foundation

struct Item: Identifiable, Hashable, Equatable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let thumbnailURL: URL?
    let imageURLs: [URL]
    let rating: Double
    let stock: Int
    let brand: String?

    static let preview = Item(
        id: 1,
        title: "Preview Product",
        description: "A sample product for SwiftUI previews.",
        category: "electronics",
        price: 29.99,
        thumbnailURL: URL(string: "https://cdn.dummyjson.com/products/images/smartphones/iPhone%205s/thumbnail.png"),
        imageURLs: [],
        rating: 4.5,
        stock: 10,
        brand: "Apple"
    )
}

extension Item {
    init(dto: ItemDTO) {
        self.id = dto.id
        self.title = dto.title
        self.description = dto.description
        self.category = dto.category
        self.price = dto.price
        self.thumbnailURL = URL(string: dto.thumbnail)
        self.imageURLs = dto.images.compactMap { URL(string: $0) }
        self.rating = dto.rating
        self.stock = dto.stock
        self.brand = dto.brand
    }
}
