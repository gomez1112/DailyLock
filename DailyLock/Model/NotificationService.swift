//
//  NotificationService.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/4/25.
//

import UserNotifications

final class ReminderScheduler {
    let id = Constants.Notification.id
    
    func currentState() async -> (enabled: Bool, authorized: Bool) {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        let pending = await center.pendingNotificationRequests()
        let hasScheduled = pending.contains { $0.identifier == id }
        return (enabled: hasScheduled, authorized: settings.authorizationStatus == .authorized)
    }
    
    func updateNotification(for time: Date) async throws {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        switch settings.authorizationStatus {
            case .notDetermined:
                do {
                    let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
                    guard granted else { throw NotificationError.permissionDenied }
                } catch {
                    throw NotificationError.permissionDenied
                }
                fallthrough
                
            case .authorized, .provisional:
                do {
                    let comps = Calendar.current.dateComponents([.hour, .minute], from: time)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Time to reflect ✍️"
                    content.body  = "What single sentence captures today?"
                    content.sound = .default
                    
                    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                    try await center.add(request)                     // iOS 17+ async API
                } catch {
                    throw NotificationError.schedulingFailed
                }
                
            case .denied, .ephemeral:
                throw NotificationError.permissionDenied
                
            @unknown default:
                throw NotificationError.schedulingFailed
        }
    }
    
    func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}

