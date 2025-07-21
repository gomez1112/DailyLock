//
//  DataModel+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation
import UserNotifications

extension DataModel {
    
    // MARK:- Notifications
    
    func addNotification(for notificationTime: Date) async -> Bool {
        do {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            
            switch settings.authorizationStatus {
                case .notDetermined:
                    let success = try await requestNotification()
                    if success {
                        try await placeNotification(for: notificationTime)
                    } else {
                        return false
                    }
                case .authorized:
                    try await placeNotification(for: notificationTime)
                default:
                    return false
            }
            return true
        } catch {
            return false
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        let id = "daily-reminder"
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    private func requestNotification() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        return try await center.requestAuthorization(options: [.alert, .sound, .badge])
    }
    
    private func placeNotification(for notificationTime: Date) async throws {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = "Time to reflect ✍️"
        content.body = "What single sentence captures today?"
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let id = "daily-reminder"
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        return try await UNUserNotificationCenter.current().add(request)
    }
}
