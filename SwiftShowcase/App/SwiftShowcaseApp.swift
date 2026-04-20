//
//  SwiftShowcaseApp.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 20/4/26.
//

import SwiftUI

@main
struct SwiftShowcaseApp: App {
    init() {
        Task {
            let service = ItemsService()
            do {
                let page = try await service.fetchItems(skip: 0, limit: 10)
                print("✅ fetchItems: \(page.items.count) items")
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
