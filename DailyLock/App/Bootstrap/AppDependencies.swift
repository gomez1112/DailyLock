//
//  AppDependencies.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/10/25.
//

import Observation
import SwiftData
import Foundation


/// A centralized container that constructs and provides all shared services and state
/// used throughout the app. This type encapsulates composition and wiring of dependencies,
/// making it easier to:
/// - Switch between live, preview, and testing configurations
/// - Share a single instance of each service across the app
/// - Inject alternate implementations during UI tests or unit tests
///
/// The class is annotated with `@Observable` so views can react to changes in any
/// observable properties exposed by the dependency graph (for example, `syncedSetting`).
///
/// Configuration
/// -------------
/// Use the `Configuration` enum to select how the dependency graph is built:
/// - `.standard`: Uses the shared on-disk `ModelContainer` for production runs
/// - `.preview`: Uses an in-memory `ModelContainer` preloaded with sample data for SwiftUI previews
/// - `.testing`: Uses an empty in-memory `ModelContainer` suited for unit tests
///
/// Provided Services
/// -----------------
/// - `syncedSetting`: Manages settings synchronized across the app or devices
/// - `notification`: Schedules and manages user notifications
/// - `dataService`: Coordinates all persistence operations backed by a `ModelContainer`
/// - `store`: High-level store that orchestrates business logic, backed by `TipLedger` and `ErrorState`
/// - `haptics`: Produces haptic feedback interactions
/// - `navigation`: Holds navigation state for coordinating flows
/// - `errorState`: Centralized error reporting and presentation state
/// - `tipLedger`: Data access layer for tip-related domain models
///
/// Initialization
/// --------------
/// The initializer accepts a `Configuration` (default `.standard`) and constructs the
/// appropriate `ModelContainer` via `ModelContainerFactory`. It then initializes all
/// dependent services, ensuring a consistent and ready-to-use graph.
///
/// UI Testing Support
/// ------------------
/// `configuredForUITests()` creates a testing-oriented graph and applies any debug
/// launch arguments via `DebugSetup.applyDebugArguments(_:container:)`, enabling tests
/// to programmatically seed data, toggle flags, or reset state as needed.
///
/// Usage
/// -----
/// Instantiate once at app launch and inject into top-level views or environment:
/// - For production: `AppDependencies()`
/// - For previews: `AppDependencies(configuration: .preview)`
/// - For tests: `AppDependencies(configuration: .testing)` or `configuredForUITests()`
@Observable
final class AppDependencies {
    enum Configuration {
        case standard       // Live app, on-disk data
        case preview        // SwiftUI Previews, in-memory with sample data
        case testing        // Unit tests, in-memory and empty
    }
   
    var syncedSetting: SyncedSetting
    let notification: NotificationService
    let dataService: DataService
    let store: Store
    let haptics: HapticEngine
    let navigation: NavigationContext
    let errorState: ErrorState
    let tipLedger: TipLedger
    
    
    init(configuration: Configuration = .standard) {
        let container: ModelContainer
        
        switch configuration {
            case .standard:
                container = ModelContainerFactory.createSharedContainer
            case .preview:
                container = ModelContainerFactory.createPreviewContainer
            case .testing:
                container = ModelContainerFactory.createEmptyContainer
        }
        self.syncedSetting = SyncedSetting()
        self.notification = NotificationService()
        self.dataService = DataService(container: container)
        self.navigation = NavigationContext()
        self.haptics = HapticEngine()
        self.errorState = ErrorState()
        let tipLedger = TipLedger(modelContainer: container)
        self.store = Store(tipLedger: tipLedger, errorState: errorState)
        self.tipLedger = TipLedger(modelContainer: container)

    }
    
    /// Creates an AppDependencies graph tailored for UI testing.
    ///
    /// This factory method builds the dependency container using the `.testing` configuration,
    /// which provides an in-memory, empty `ModelContainer` suitable for deterministic and fast tests.
    /// After initialization, it inspects the current process’s launch arguments and applies any
    /// debug/test directives to the data layer via `DebugSetup.applyDebugArguments(_:container:)`.
    /// This enables UI tests to programmatically seed data, toggle feature flags, or reset state
    /// without modifying production code.
    ///
    /// Behavior:
    /// - Uses `Configuration.testing` to avoid persisting data to disk.
    /// - Applies launch-argument driven setup to the underlying `ModelContainer`.
    ///
    /// Typical usage in UI test setup:
    /// - Pass arguments (e.g., `-resetData`, `-seedSampleData`) to the test runner.
    /// - Call this method at app launch to ensure the app is configured accordingly.
    ///
    /// - Returns: A fully configured `AppDependencies` instance optimized for UI tests.
    static func configuredForUITests() -> AppDependencies {
        let config: Configuration = .testing
        let deps = AppDependencies(configuration: config)
        let arguments = ProcessInfo.processInfo.arguments
        DebugSetup.applyDebugArguments(arguments, container: deps.dataService.context.container)
        return deps
    }
}
