//
//  NotificationPermissionView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/24/25.
//

import SwiftUI
import UserNotifications


struct NotificationPermissionView: View {
    @State private var showBells = false
    @State private var animationTask: Task<Void, Never>?
    @Environment(AppDependencies.self) private var dependencies
    
    let onComplete: () -> Void
    
    var body: some View {
        @Bindable var dependencies = dependencies
        
        OnboardingPageView {
            HStack(spacing: AppNotificationPermissionView.bellSpacing) {
                ForEach(0..<AppNotificationPermissionView.bellCount, id: \.self) { index in
                    Image(systemName: "bell.fill")
                        .font(.system(size: AppNotificationPermissionView.bellSize))
                        .foregroundStyle(.accent)
                        .symbolEffect(.bounce.up.byLayer, options: .repeating, value: showBells)
                        .animation(
                            .easeInOut(duration: 0.5)
                            .repeatCount(3, autoreverses: true) // Limited repetitions
                                .delay(Double(index) * 0.1),
                            value: showBells
                        )
                }
            }
            .onAppear {
                showBells = true
            }
            .onDisappear {
                showBells = false // Clean up animation state
                animationTask?.cancel()
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("bellAnimationHStack")
            .accessibilityLabel("Animated bells")
        } content: {
            
            VStack(spacing: AppNotificationPermissionView.titleSpacing) {
                Text("Daily Reminders")
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibilityIdentifier("notificationTitle")
                    .accessibilityAddTraits(.isHeader)
                
                Text("Get a gentle nudge to capture your day")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("notificationSubtitle")
                    .lineLimit(2...2)
                    .multilineTextAlignment(.center)
                
                // Time picker
                VStack(spacing: AppNotificationPermissionView.timePickerSpacing) {
                    Text("Choose your preferred time:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier("timePickerLabel")
                    
                    DatePicker(
                        "Notification Time",
                        selection: $dependencies.syncedSetting.notificationTime,
                        displayedComponents: .hourAndMinute
                    )
#if !os(macOS)
                    .datePickerStyle(.wheel)
#endif
                    .datePickerStyle(.automatic)
                    .labelsHidden()
                    .frame(height: AppNotificationPermissionView.timePickerHeight)
                    .accessibilityIdentifier("notificationTimePicker")
                    .accessibilityLabel("Preferred notification time picker")
                }
                Button {
                    Task {
                        await requestNotificationPermission()
                        onComplete()
                    }
                } label: {
                    Label("Enable Notifications", systemImage: "bell.badge")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: AppNotificationPermissionView.enableButtonCornerRadius))
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("enableNotificationsButton")
                .accessibilityHint("Allows DailyLock to send you reminders at your chosen time.")
                
                Button("Maybe Later") {
                    onComplete()
                }
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("maybeLaterButton")
                .accessibilityHint("Continue without setting reminders.")
            }
        }
    }
    
    private func requestNotificationPermission() async {
        let center = UNUserNotificationCenter.current()
        
        let permissionGranted = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
        
        // Only proceed if permission was actually granted
        if permissionGranted == true {
            // ✅ 4. Save the settings using the manager
            dependencies.syncedSetting.save(notifications: true)
            dependencies.syncedSetting.save(time: dependencies.syncedSetting.notificationTime)
            
            // Schedule the notification using the time from the manager
            let content = UNMutableNotificationContent()
            content.title = "Time to reflect ✍️"
            content.body = "What single sentence captures today?"
            content.sound = .default
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: dependencies.syncedSetting.notificationTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: AppNotification.id,
                content: content,
                trigger: trigger
            )
            
            try? await center.add(request)
        }
    }
}

#Preview(traits: .previewData) {
    NotificationPermissionView(onComplete: {})
}
