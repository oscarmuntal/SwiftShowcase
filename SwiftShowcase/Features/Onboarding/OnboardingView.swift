//
//  OnboardingView.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 22/4/26.
//

import SwiftUI

struct OnboardingView: View {
    let itemsService: ItemsServiceProtocol

    @AppStorage(StorageKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @Environment(NavigationState.self) private var navigationState
    @Environment(\.dismiss) private var dismiss
    @State private var pageIndex = 0

    var body: some View {
        VStack {
            TabView(selection: $pageIndex) {
                OnboardingPageView(
                    systemImage: "sparkles",
                    title: "Welcome to SwiftShowcase",
                    subtitle: "A small portfolio app demonstrating modern SwiftUI."
                )
                .tag(0)

                OnboardingPageView(
                    systemImage: "magnifyingglass",
                    title: "Browse and search",
                    subtitle: "Pull to refresh, infinite scroll, and remote search."
                )
                .tag(1)

                OnboardingPageView(
                    systemImage: "star.fill",
                    title: "Save favorites",
                    subtitle: "Tap the star on any product."
                )
                .tag(2)
            }
            .tabViewStyle(.page)

            Button {
                if pageIndex < 2 {
                    withAnimation {
                        pageIndex += 1
                    }
                } else {
                    Task { await finishAndJumpToFirstProduct() }
                }
            } label: {
                Text(pageIndex < 2 ? "Next" : "Take me to the first product")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }

    private func finishAndJumpToFirstProduct() async {
        do {
            let page = try await itemsService.fetchItems(skip: 0, limit: 1)
            if let firstItem = page.items.first {
                navigationState.homePath.append(firstItem)
            }
        } catch {
            // Fetch failed — user lands on Home without jumping to detail
            // This is intentional: onboarding completes regardless
            print("finishAndJumpToFirstProduct: fetch failed — \(error)")
        }
        navigationState.selectedTab = .home
        hasCompletedOnboarding = true
        dismiss()
    }
}

private struct OnboardingPageView: View {
    let systemImage: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 64))
                .foregroundStyle(.blue)
            Text(title)
                .font(.title)
                .bold()
            Text(subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
}

#Preview {
    OnboardingView(itemsService: PreviewOnboardingItemsService())
        .environment(NavigationState())
}

private struct PreviewOnboardingItemsService: ItemsServiceProtocol {
    func fetchItems(skip: Int, limit: Int) async throws -> ItemsPage {
        ItemsPage(items: [.preview], total: 1, skip: 0, limit: 1)
    }

    func searchItems(query: String) async throws -> [Item] {
        [.preview]
    }

    func fetchItems(byIds ids: [Int]) async throws -> [Item] {
        [.preview]
    }
}
