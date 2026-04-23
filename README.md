# SwiftShowcase

A portfolio iOS app demonstrating modern SwiftUI, MVVM, and Swift Concurrency patterns — zero third-party dependencies.

## What this project demonstrates

- **SwiftUI + MVVM on iOS 17** with `@Observable` ViewModels (Observation framework, not Combine's `ObservableObject`)
- **Feature-based folder organization** where code that changes together lives together
- **Infinite-scroll pagination** triggered by `.onAppear` on the last visible row
- **Remote search** via a dedicated `/products/search` endpoint, debounced with Combine
- **Fetch-by-IDs pattern** for Favorites — fetches only the items the user saved, not the entire catalog
- **Full navigation stack**: `NavigationStack` + `NavigationPath` per tab, `.sheet`, `.fullScreenCover`, and programmatic push from onboarding
- **async/await + parallel `TaskGroup`** for concurrent network requests with per-item resilience
- **Focused Combine usage** — a single `CurrentValueSubject` for search debounce; everything else is Swift Concurrency
- **Protocol-based dependency injection** without containers or frameworks
- **`@AppStorage` persistence** for favorites (as JSON-encoded IDs) and user preferences
- **Automatic DEBUG banner** via `#if DEBUG` — always visible in debug builds, never in release
- **Three-mode appearance Picker** (System / Light / Dark) applied at the root
- **Unit tests with mocks** covering ViewModel logic and persistence

## Architecture

```
┌──────────────────────────────────────────┐
│                  App                     │
│  (SwiftShowcaseApp, RootTabsView,        │
│   NavigationState)                       │
├──────────────────────────────────────────┤
│               Features                   │
│  Home  Detail  Favorites  Settings       │
│  Onboarding                              │
├──────────────────────────────────────────┤
│              Components                  │
│  ItemRowView, StateRenderingView,        │
│  LoadingView, ErrorView, EmptyStateView  │
├──────────────────────────────────────────┤
│                 Core                     │
│  Models  Networking  Persistence         │
│  Utilities                               │
└──────────────────────────────────────────┘
```

Dependencies flow **downward only**: `App` -> `Features` -> `Components` -> `Core`. Features never import other features.

## Folder structure

```
SwiftShowcase/
├── App/
│   ├── SwiftShowcaseApp.swift      # Composition root
│   ├── RootTabsView.swift          # TabView with 3 tabs
│   └── NavigationState.swift       # Shared @Observable nav state
├── Features/
│   ├── Home/                       # Paginated browse + search
│   ├── Detail/                     # Product detail + info sheet
│   ├── Favorites/                  # Saved items (fetch-by-IDs)
│   ├── Settings/                   # Appearance, ordering, onboarding reset
│   └── Onboarding/                 # First-launch walkthrough
├── Components/
│   ├── ItemRowView.swift           # Reusable product row
│   └── ViewState/                  # LoadingView, ErrorView, EmptyStateView, StateRenderingView
├── Core/
│   ├── Models/                     # Item, ItemDTO, ItemsPage, ViewState, AppearanceMode
│   ├── Networking/                 # ItemsService, ItemsServiceProtocol, APIError
│   ├── Persistence/                # FavoritesStore, FavoritesStoreProtocol
│   └── Utilities/                  # ErrorMessageMapper
└── SwiftShowcaseTests/
    ├── HomeViewModelTests.swift
    ├── FavoritesStoreTests.swift
    ├── MockItemsService.swift
    └── MockFavoritesStore.swift
```

## Screens

| Screen | Description |
|--------|-------------|
| **Home** | Paginated product list with pull-to-refresh, infinite scroll, and remote search |
| **Detail** | Hero image, product info, favorite toggle, info sheet |
| **Favorites** | Items saved by the user, fetched by IDs, swipe-to-remove |
| **Settings** | Appearance mode picker, "show favorites first" toggle, onboarding reset |
| **InfoSheet** | Expandable product details presented as a sheet from Detail |
| **Onboarding** | Three-page walkthrough on first launch, navigates to first product on completion |

## Running the project

1. Clone the repo
2. Open `SwiftShowcase.xcodeproj` in **Xcode 15+**
3. Select an **iOS 17+** simulator
4. Run (Cmd+R)

No dependencies to install. No configuration files needed.

## Tests

```
Cmd+U
```

- `HomeViewModelTests` — load success/empty/error, pagination, loadMore guards
- `FavoritesStoreTests` — add/remove, persistence across instances, corruption recovery

All tests use protocol-based mocks with no network access.

## API

The app uses [DummyJSON](https://dummyjson.com) as its backend:

| Endpoint | Usage |
|----------|-------|
| `GET /products?skip={N}&limit={20}` | Paginated browse |
| `GET /products/search?q={query}` | Remote search |
| `GET /products/{id}` | Single item by ID (used by Favorites via parallel TaskGroup) |

## What's intentionally NOT here

| Omission | Reasoning |
|----------|-----------|
| **Coordinators / Router** | NavigationStack + NavigationPath handle all navigation declaratively; an extra layer adds complexity without benefit at this scale. |
| **TCA / VIPER** | MVVM is the idiomatic SwiftUI architecture; heavier patterns add indirection that isn't justified at this scale. |
| **Core Data / SwiftData** | The app persists only a small list of integer IDs via `UserDefaults` — a full database stack would be overkill for this use case. |
| **Third-party libraries** | The app relies exclusively on Apple frameworks to keep the dependency footprint at zero. |
| **Combine (beyond search)** | async/await covers all async needs; Combine is used only for search debounce, where its reactive operators are a natural fit. |

## License

MIT
