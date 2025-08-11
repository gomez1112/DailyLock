//
//  NotificationSection.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/21/25.
//

import SwiftUI

struct NotificationSection: View {
    
    @Environment(AppDependencies.self) private var dependencies
    
    @State private var notification = ReminderScheduler()
    @State private var isUpdating = false
    
    @AppStorage("notificationTime") private var notificationTime = Date()
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    
    var body: some View {
        Section {
            Toggle(isOn: $notificationsEnabled.animation()) {
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
            .onChange(of: notificationsEnabled) { _, newValue in
                Task {
                    await handleNotificationToggle(newValue: newValue)
                }
            }
            
            if notificationsEnabled {
                DatePicker(selection: $notificationTime, displayedComponents: .hourAndMinute) {
                    Label("Time", systemImage: "clock")
                        .symbolRenderingMode(.hierarchical)
                        .accessibilityIdentifier("timePickerLabel")
                }
                .disabled(isUpdating)
                .onChange(of: notificationTime) { _, newTime in
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
        
        if notificationsEnabled != shouldBeOn {
            notificationsEnabled = shouldBeOn
        }
    }
    

    private func handleNotificationToggle(newValue: Bool) async {
        isUpdating = true
        
        defer { isUpdating = false }
        if newValue {
            do {
                try await notification.updateNotification(for: notificationTime)
                notificationsEnabled = true
            } catch let app as AppError {
                notificationsEnabled = false
                dependencies.errorState.show(app)
            } catch {
                notificationsEnabled = false
            }
        } else {
            notification.removeNotification()
        }
    }
    

    private func handleTimeChange(newTime: Date) async {
        guard notificationsEnabled else { return }
        isUpdating = true
        defer { isUpdating = false }
        
        do {
            try await notification.updateNotification(for: newTime)
        } catch let app as AppError {
            // Revert toggle if we can't reschedule at the new time
            notificationsEnabled = false
            dependencies.errorState.show(app)
        } catch {
            notificationsEnabled = false
            dependencies.errorState.show(NotificationError.schedulingFailed)
        }
    }
}

#Preview(traits: .previewData) {
    NotificationSection()
}
