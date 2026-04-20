import Foundation

struct ItemDTO: Decodable {
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

struct ProductsResponseDTO: Decodable {
    let products: [ItemDTO]
    let total: Int
    let skip: Int
    let limit: Int
}
