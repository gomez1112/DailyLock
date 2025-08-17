//
//  AppDependencies.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/10/25.
//

import Observation
import SwiftData
import Foundation

@Observable
final class AppDependencies {
    enum Configuration {
        case standard       // Live app, on-disk data
        case preview        // SwiftUI Previews, in-memory with sample data
        case testing        // Unit tests, in-memory and empty
    }
    let healthStore: HealthStore
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
                container = ModelContainerFactory.createEmptyContainer()
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
        self.healthStore = HealthStore(errorState: errorState)
    }
    
    static func configuredForUITests() -> AppDependencies {
        let config: Configuration = .testing
        let deps = AppDependencies(configuration: config)
        let arguments = ProcessInfo.processInfo.arguments
        DebugSetup.applyDebugArguments(arguments, container: deps.dataService.context.container)
        return deps
    }
}
