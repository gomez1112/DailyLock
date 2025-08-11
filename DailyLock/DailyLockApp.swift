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
    
    @State private var dependencies = AppDependencies()
    
    init() {
        Log.app.info("App is initializing.")
        let arguments = ProcessInfo.processInfo.arguments
        let isUITesting = arguments.contains("enabl-testing")
        let configuration: AppDependencies.Configuration = isUITesting ? .testing : .standard
        let appDependencies = AppDependencies(configuration: configuration)
        
        if isUITesting {
            DebugSetup.applyDebugArguments(arguments, container: appDependencies.dataService.context.container)
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
                    navigation.navigate(to: .today)
                }
                .keyboardShortcut("n", modifiers: .command)
            }
            CommandMenu("Navigation") {
                Button("Today") {
                    navigation.navigate(to: .today)
                }
                .keyboardShortcut("1", modifiers: .command)
                
                Button("Timeline") {
                    navigation.navigate(to: .timeline)
                }
                .keyboardShortcut("2", modifiers: .command)
                
                Button("Insights") {
                    navigation.navigate(to: .insights)
                }
                .keyboardShortcut("3", modifiers: .command)
            }
        }
        #endif
        #if os(macOS)
        Settings {
            SettingsView()
                .environment(model)
                .environment(navigation)
                .environment(hapticEngine)
                .environment(store)
                .modelContainer(container)
                .frame(width: AppLayout.settingsWindowWidth, height: AppLayout.settingsWindowHeight)
        }
        #endif
    }
    private func configureAppIntents(with dependencies: AppDependencies) {
        AppDependencyManager.shared.add(dependency: dependencies)
    }
}
