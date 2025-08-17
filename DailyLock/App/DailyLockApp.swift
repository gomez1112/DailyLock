//
//  DailyLockApp.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import AppIntents
#if !os(macOS)
import HealthKit
import HealthKitUI
#endif
import SwiftData
import SwiftUI
import os

@main
struct DailyLockApp: App {
    #if !os(macOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    @State private var dependencies: AppDependencies
    
    init() {
        Log.app.info("App is initializing.")
        if ProcessInfo.processInfo.arguments.contains("enable-testing") {
            _dependencies = State(initialValue: AppDependencies.configuredForUITests())
        } else {
            _dependencies = State(initialValue: AppDependencies())
        }
        
        let container = dependencies.dataService.context.container
        configureAppIntents(with: dependencies)
        AppDependencyManager.shared.add(dependency: container)

    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .trackDeviceStatus()
                .withErrorHandling()
        }
        .environment(dependencies)
        .modelContainer(dependencies.dataService.context.container)
        

        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Entry") {
                    dependencies.navigation.navigate(to: .today)
                }
                .keyboardShortcut("n", modifiers: .command)
            }
            CommandMenu("Navigation") {
                Button("Today") {
                    dependencies.navigation.navigate(to: .today)
                }
                .keyboardShortcut("1", modifiers: .command)
                
                Button("Timeline") {
                    dependencies.navigation.navigate(to: .timeline)
                }
                .keyboardShortcut("2", modifiers: .command)
                
                Button("Insights") {
                    dependencies.navigation.navigate(to: .insights)
                }
                .keyboardShortcut("3", modifiers: .command)
            }
        }
        #endif
        #if os(macOS)
        Settings {
            SettingsView()
                .trackDeviceStatus()
                .withErrorHandling()
                .environment(dependencies)
                .modelContainer(dependencies.dataService.context.container)
                .frame(width: AppLayout.settingsWindowWidth, height: AppLayout.settingsWindowHeight)
        }
        #endif
    }
    private func configureAppIntents(with dependencies: AppDependencies) {
        AppDependencyManager.shared.add(dependency: dependencies)
    }
    #if !os(macOS)
    private var healthKitReadTypes: Set<HKObjectType> {
        var types: Set<HKObjectType> = [HKObjectType.stateOfMindType()]
        
        // Add additional types for correlation analysis
        if #available(iOS 16.0, *) {
            types.insert(HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!)
        }
        types.insert(HKObjectType.categoryType(forIdentifier: .mindfulSession)!)
        
        return types
    }
    #endif
}

