//
//  SyncedSetting.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/15/25.
//

import Foundation
import Combine

@MainActor
@Observable
final class SyncedSetting {
    
    // --- Your Synced Properties ---
    var selectedTexture: String
    var allowGracePeriod: Bool
    var notificationsEnabled: Bool
    var notificationTime: Date
    var hasCompletedOnboarding: Bool
    // Add any other settings you want to sync here...
    
    private let store = NSUbiquitousKeyValueStore.default
    
    init() {
        // --- Load Initial Values ---
        // Load values from iCloud or use defaults if they don't exist.
        self.hasCompletedOnboarding = store.bool(forKey: "hasCompletedOnboarding")
        self.selectedTexture = store.object(forKey: "selectedTexture") as? String ?? "defaultDarkPaper"
        self.allowGracePeriod = store.bool(forKey: "allowGracePeriod")
        self.notificationsEnabled = store.bool(forKey: "notificationsEnabled")
        
        // For Date, we store it as a TimeInterval (a Double)
        let savedTime = store.double(forKey: "notificationTime")
        if savedTime > 0 {
            self.notificationTime = Date(timeIntervalSince1970: savedTime)
        } else {
            // Default to 8:00 PM
            self.notificationTime = Calendar.current.date(from: DateComponents(hour: 20, minute: 0)) ?? Date()
        }
        
        // --- Set up ONE Observer for ALL Changes ---
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateFromCloud),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: store
        )
        
        store.synchronize() // Perform an initial sync to get the latest data.
    }
    
    // This function is called whenever a change comes in from iCloud.
    @objc private func updateFromCloud() {
        // Refetch all values from the store.
        hasCompletedOnboarding = store.bool(forKey: "hasCompletedOnboarding")
        selectedTexture = store.object(forKey: "selectedTexture") as? String ?? "default"
        allowGracePeriod = store.bool(forKey: "allowGracePeriod")
        notificationsEnabled = store.bool(forKey: "notificationsEnabled")
        
        let savedTime = store.double(forKey: "notificationTime")
        if savedTime > 0 {
            notificationTime = Date(timeIntervalSince1970: savedTime)
        }
    }
    
    // --- Helper Methods to Save Changes ---
    // We will call these from our views when a setting is changed.
    
    func save(onboardingCompleted: Bool) {
        hasCompletedOnboarding = onboardingCompleted
        store.set(onboardingCompleted, forKey: "hasCompletedOnboarding")
    }
    
    func save(texture: String) {
        selectedTexture = texture
        store.set(texture, forKey: "selectedTexture")
    }
    
    func save(gracePeriod: Bool) {
        allowGracePeriod = gracePeriod
        store.set(gracePeriod, forKey: "allowGracePeriod")
    }
    
    func save(notifications: Bool) {
        notificationsEnabled = notifications
        store.set(notifications, forKey: "notificationsEnabled")
    }
    
    func save(time: Date) {
        notificationTime = time
        // Convert Date to a Double (TimeInterval) for iCloud KVS
        store.set(time.timeIntervalSince1970, forKey: "notificationTime")
    }
}

