//
//  DailyLockApp.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import AppIntents
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
        
        let navigation = dependencies.navigation
        let dataService = dependencies.dataService
        let syncedSetting = dependencies.syncedSetting
        let store = dependencies.store
        let errorState = dependencies.errorState
        
        AppDependencyManager.shared.add(dependency: navigation)
        AppDependencyManager.shared.add(dependency: dataService)
        AppDependencyManager.shared.add(dependency: syncedSetting)
        AppDependencyManager.shared.add(dependency: store)
        AppDependencyManager.shared.add(dependency: errorState)
        
        DailyLockShortcuts.updateAppShortcutParameters()
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
}

