import Foundation

protocol ItemsServiceProtocol {
    func fetchItems(skip: Int, limit: Int) async throws -> ItemsPage
    func searchItems(query: String) async throws -> [Item]
    func fetchItems(byIds ids: [Int]) async throws -> [Item]
}
