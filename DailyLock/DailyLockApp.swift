//
//  DailyLockApp.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import AppIntents
import SwiftData
import SwiftUI

@main
struct DailyLockApp: App {
    #if !os(macOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    @State private var hapticEngine = HapticEngine()
    
    private let model: DataModel
    private let navigation: NavigationContext
    private let container = ModelContainerFactory.createSharedContainer
    
    init() {
        let model = DataModel(container: container)
        let navigation = NavigationContext()
        let hapticEngine = HapticEngine()
        
        self.model = model
        self.navigation = navigation
        self.hapticEngine = hapticEngine
        
        AppDependencyManager.shared.add(dependency: model)
        AppDependencyManager.shared.add(dependency: navigation)
        AppDependencyManager.shared.add(dependency: hapticEngine)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800)
        }
        .environment(model)
        .environment(navigation)
        .environment(hapticEngine)
        .modelContainer(container)
        
        #if os(macOS)
        .windowResizability(.contentSize)
        #endif
        #if os(macOS)
        Settings {
            SettingsView()
                .environment(model)
                .environment(navigation)
                .environment(hapticEngine)
                .modelContainer(container)
        }
        #endif
    }
}
#if !os(macOS)
// MARK: - App Delegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }
}
#endif
