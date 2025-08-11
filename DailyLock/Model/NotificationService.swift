// NotificationService.swift

import UserNotifications

@MainActor
final class NotificationService {
    
    func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Failed to request notification permission: \(error)")
            return false
        }
    }
    
    func scheduleDailyReminder(at date: Date) async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        guard settings.authorizationStatus == .authorized else {
            // Attempt to request permission if not determined
            if settings.authorizationStatus == .notDetermined {
                return await requestPermission() && scheduleDailyReminder(at: date)
            }
            return false
        }
        
        // Cancel any existing reminders before scheduling a new one
        cancelReminders()
        
        let content = UNMutableNotificationContent()
        content.title = "Time to reflect ✍️"
        content.body = "What single sentence captures today?"
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: AppNotification.id, content: content, trigger: trigger)
        
        do {
            try await center.add(request)
            return true
        } catch {
            print("Failed to schedule notification: \(error)")
            return false
        }
    }
    
    func cancelReminders() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [AppNotification.id])
    }
}