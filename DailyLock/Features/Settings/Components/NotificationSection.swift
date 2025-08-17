//
//  NotificationSection.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/21/25.
//

import SwiftUI

struct NotificationSection: View {
    
    @Environment(AppDependencies.self) private var dependencies
    
    @State private var notification = NotificationService()
    @State private var isUpdating = false
    
    var body: some View {
        @Bindable var dependencies = dependencies
        Section {
            Toggle(isOn: $dependencies.syncedSetting.notificationsEnabled.animation()) {
                Label {
                    VStack(alignment: .leading) {
                        Text("Daily Reminder")
                            .font(.body)
                            .accessibilityIdentifier("dailyReminderTitle")
                        Text("A gentle nudge to capture today")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .accessibilityIdentifier("dailyReminderCaption")
                    }
                } icon: {
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.accent)
                        .accessibilityIdentifier("dailyReminderIcon")
                        .accessibilityLabel("Reminder Notifications")
                }
            }
            .tint(.accent)
            .disabled(isUpdating)
            .accessibilityIdentifier("dailyReminderToggle")
            .onChange(of: dependencies.syncedSetting.notificationsEnabled) { _, newValue in
                dependencies.syncedSetting.save(notifications: newValue)
                Task {
                    await handleNotificationToggle(newValue: newValue)
                }
            }
            
            if dependencies.syncedSetting.notificationsEnabled {
                DatePicker(selection: $dependencies.syncedSetting.notificationTime, displayedComponents: .hourAndMinute) {
                    Label("Time", systemImage: "clock")
                        .symbolRenderingMode(.hierarchical)
                        .accessibilityIdentifier("timePickerLabel")
                }
                .disabled(isUpdating)
                .onChange(of: dependencies.syncedSetting.notificationTime) { _, newTime in
                    dependencies.syncedSetting.save(time: newTime)
                    Task {
                        await handleTimeChange(newTime: newTime)
                    }
                }
            }
            if isUpdating {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Updating notification...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .task {
            await syncNotificationState()
        }
    }

    private func syncNotificationState() async {
        let state = await notification.currentState()
        
        let shouldBeOn = state.enabled && state.authorized
        
        if dependencies.syncedSetting.notificationsEnabled != shouldBeOn {
            dependencies.syncedSetting.notificationsEnabled = shouldBeOn
        }
    }
    

    private func handleNotificationToggle(newValue: Bool) async {
        isUpdating = true
        
        defer { isUpdating = false }
        if newValue {
            do {
                try await notification.updateNotification(for: dependencies.syncedSetting.notificationTime)
                dependencies.syncedSetting.notificationsEnabled = true
            } catch let app as AppError {
                dependencies.syncedSetting.save(notifications: false)
                dependencies.errorState.show(app)
            } catch {
                dependencies.syncedSetting.save(notifications: false)
            }
        } else {
            notification.removeNotification()
        }
    }
    

    private func handleTimeChange(newTime: Date) async {
        guard dependencies.syncedSetting.notificationsEnabled else { return }
        isUpdating = true
        defer { isUpdating = false }
        
        do {
            try await notification.updateNotification(for: newTime)
        } catch let app as AppError {
            // Revert toggle if we can't reschedule at the new time
            dependencies.syncedSetting.save(notifications: false)
            dependencies.errorState.show(app)
        } catch {
            dependencies.syncedSetting.save(notifications: false)
            dependencies.errorState.show(NotificationError.schedulingFailed)
        }
    }
}

#Preview(traits: .previewData) {
    NotificationSection()
}
