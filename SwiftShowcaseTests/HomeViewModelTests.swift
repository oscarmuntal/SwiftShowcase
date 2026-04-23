//
//  HomeViewModelTests.swift
//  SwiftShowcaseTests
//
//  Created by Òscar Muntal on 23/4/26.
//

import XCTest
@testable import SwiftShowcase

final class HomeViewModelTests: XCTestCase {

    private var service: MockItemsService!
    private var store: MockFavoritesStore!
    private var sut: HomeViewModel!

    override func setUp() {
        super.setUp()
        service = MockItemsService()
        store = MockFavoritesStore()
        sut = HomeViewModel(itemsService: service, favoritesStore: store)
    }

    override func tearDown() {
        sut = nil
        store = nil
        service = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func makeItem(id: Int) -> Item {
        Item(
            id: id,
            title: "Item \(id)",
            description: "Description",
            category: "test",
            price: 9.99,
            thumbnailURL: nil,
            imageURLs: [],
            rating: 4.0,
            stock: 10,
            brand: nil
        )
    }

    private func makeItems(count: Int, startingAt start: Int = 1) -> [Item] {
        (start..<start + count).map { makeItem(id: $0) }
    }

    // MARK: - load()

    func test_load_success_setsLoadedState() async {
        let items = makeItems(count: 2)
        service.fetchItemsResult = .success(ItemsPage(items: items, total: 2, skip: 0, limit: 20))

        await sut.load()

        XCTAssertEqual(sut.state, .loaded(items))
        XCTAssertEqual(sut.currentSkip, 0)
        XCTAssertFalse(sut.hasMorePages)
    }

    func test_load_emptyResponse_setsEmptyState() async {
        service.fetchItemsResult = .success(ItemsPage(items: [], total: 0, skip: 0, limit: 20))

        await sut.load()

        XCTAssertEqual(sut.state, .empty)
    }

    func test_load_failure_setsErrorState() async {
        service.fetchItemsResult = .failure(APIError.badStatus(500))

        await sut.load()

        XCTAssertEqual(sut.state, .error(APIError.badStatus(500).userMessage))
    }

    // MARK: - loadMore()

    func test_loadMore_appendsItems() async {
        let firstPage = makeItems(count: 20)
        service.fetchItemsResult = .success(ItemsPage(items: firstPage, total: 100, skip: 0, limit: 20))
        await sut.load()

        let secondPage = makeItems(count: 20, startingAt: 21)
        service.fetchItemsResult = .success(ItemsPage(items: secondPage, total: 100, skip: 20, limit: 20))
        await sut.loadMore()

        XCTAssertEqual(sut.items.count, 40)
        XCTAssertEqual(sut.currentSkip, 20)
        XCTAssertTrue(sut.hasMorePages)
    }

    func test_loadMore_isNoOp_whenAlreadyLoading() async {
        let items = makeItems(count: 20)
        service.fetchItemsResult = .success(ItemsPage(items: items, total: 50, skip: 0, limit: 20))
        await sut.load()

        let callCountBefore = service.fetchItemsCalls.count
        sut.isLoadingMore = true
        await sut.loadMore()

        XCTAssertEqual(service.fetchItemsCalls.count, callCountBefore)
    }

    func test_loadMore_isNoOp_whenNoMorePages() async {
        let items = makeItems(count: 2)
        service.fetchItemsResult = .success(ItemsPage(items: items, total: 2, skip: 0, limit: 20))
        await sut.load()
        XCTAssertFalse(sut.hasMorePages)

        let callCountBefore = service.fetchItemsCalls.count
        await sut.loadMore()

        XCTAssertEqual(service.fetchItemsCalls.count, callCountBefore)
    }
}
