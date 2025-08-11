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
    @State private var notificationTime = Calendar.current.date(
        from: DateComponents(hour: 20, minute: 0)
    ) ?? Date()
    
    var body: some View {
        VStack(spacing: AppNotificationPermissionView.mainVStackSpacing) {
            Spacer()
            
            // Animated bells
            HStack(spacing: AppNotificationPermissionView.bellSpacing) {
                ForEach(0..<AppNotificationPermissionView.bellCount, id: \.self) { index in
                    Image(systemName: "bell.fill")
                        .font(.system(size: AppNotificationPermissionView.bellSize))
                        .foregroundStyle(.accent)
                        .symbolEffect(.bounce.up.byLayer, options: .repeating, value: showBells)
                        .animation(.easeInOut(duration: AppNotificationPermissionView.bellsAnimationDuration), value: showBells)
                }
            }
            .onAppear { showBells = true }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("bellAnimationHStack")
            .accessibilityLabel("Animated bells")
            
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
                
                // Time picker
                VStack(spacing: AppNotificationPermissionView.timePickerSpacing) {
                    Text("Choose your preferred time:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier("timePickerLabel")
                    
                    DatePicker(
                        "Notification Time",
                        selection: $notificationTime,
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
                .padding(.top)
            }
            
            Spacer()
            
            Button {
                Task {
                    await requestNotificationPermission()
                }
            } label: {
                Label("Enable Notifications", systemImage: "bell.badge")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppNotificationPermissionView.enableButtonCornerRadius))
            }
            .padding(.horizontal, AppNotificationPermissionView.contentHorizontalPadding)
            .accessibilityIdentifier("enableNotificationsButton")
            .accessibilityHint("Allows DailyLock to send you reminders at your chosen time.")
            
            Button("Maybe Later") {
                // Continue without notifications
            }
            .foregroundStyle(.secondary)
            .accessibilityIdentifier("maybeLaterButton")
            .accessibilityHint("Continue without setting reminders.")
            
            Spacer()
        }
        .padding(.horizontal, AppNotificationPermissionView.contentHorizontalPadding)
    }
    
    private func requestNotificationPermission() async {
        let center = UNUserNotificationCenter.current()
        _ = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
        
        UserDefaults.standard.set(notificationTime, forKey: "notificationTime")
        UserDefaults.standard.set(true, forKey: "notificationsEnabled")
        
        // Schedule notification at selected time
        let content = UNMutableNotificationContent()
        content.title = "Time to reflect ✍️"
        content.body = "What single sentence captures today?"
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: AppNotification.id,
            content: content,
            trigger: trigger
        )
        
        try? await center.add(request)
    }
}

#Preview {
    NotificationPermissionView()
}
