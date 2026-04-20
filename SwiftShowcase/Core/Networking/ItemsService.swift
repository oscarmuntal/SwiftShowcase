import Foundation

struct ItemsService: ItemsServiceProtocol {

    private let session: URLSession
    private let baseURL = "https://dummyjson.com/products"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchItems(skip: Int, limit: Int) async throws -> ItemsPage {
        guard var components = URLComponents(string: baseURL) else {
            throw APIError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "skip", value: "\(skip)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        guard let url = components.url else {
            throw APIError.invalidURL
        }

        let dto: ProductsResponseDTO = try await fetch(url: url)
        return ItemsPage(
            items: dto.products.map(Item.init(dto:)),
            total: dto.total,
            skip: dto.skip,
            limit: dto.limit
        )
    }

    func searchItems(query: String) async throws -> [Item] {
        guard var components = URLComponents(string: "\(baseURL)/search") else {
            throw APIError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]
        guard let url = components.url else {
            throw APIError.invalidURL
        }

        let dto: ProductsResponseDTO = try await fetch(url: url)
        return dto.products.map(Item.init(dto:))
    }

    func fetchItems(byIds ids: [Int]) async throws -> [Item] {
        guard !ids.isEmpty else { return [] }

        let baseURL = self.baseURL
        let service = self
        
        let itemsByID = try await withThrowingTaskGroup(of: (Int, Item).self) { group in
            for id in ids {
                group.addTask {
                    guard let url = URL(string: "\(baseURL)/\(id)") else {
                        throw APIError.invalidURL
                    }
                    let dto: ItemDTO = try await service.fetch(url: url)
                    return (id, Item(dto: dto))
                }
            }

            var result: [Int: Item] = [:]
            for try await (id, item) in group {
                result[id] = item
            }
            return result
        }

        return ids.compactMap { itemsByID[$0] }
    }

    // MARK: - Private

    private func fetch<T: Decodable>(url: URL) async throws -> T {
        let data: Data
        let response: URLResponse
        let decoder = JSONDecoder()

        do {
            (data, response) = try await session.data(from: url)
        } catch let error as URLError {
            throw APIError.transport(error.code)
        } catch {
            throw APIError.unknown
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw APIError.badStatus(statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding
        }
    }
}
