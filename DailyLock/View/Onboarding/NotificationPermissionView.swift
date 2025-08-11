struct NotificationPermissionView: View {
    @State private var showBells = false
    @State private var notificationTime = Calendar.current.date(
        from: DateComponents(hour: 20, minute: 0)
    ) ?? Date()
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Animated bells
            HStack(spacing: 20) {
                ForEach(0..<3) { index in
                    Image(systemName: "bell.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.orange)
                        .symbolEffect(
                            .bounce.up.byLayer,
                            options: .repeating.delay(Double(index) * 0.2),
                            value: showBells
                        )
                }
            }
            .onAppear { showBells = true }
            
            VStack(spacing: 16) {
                Text("Daily Reminders")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Get a gentle nudge to capture your day")
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                // Time picker
                VStack(spacing: 12) {
                    Text("Choose your preferred time:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    DatePicker(
                        "",
                        selection: $notificationTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(height: 120)
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
                    .background(.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal)
            
            Button("Maybe Later") {
                // Continue without notifications
            }
            .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private func requestNotificationPermission() async {
        let center = UNUserNotificationCenter.current()
        _ = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
        
        // Schedule notification at selected time
        let content = UNMutableNotificationContent()
        content.title = "Time to reflect ✍️"
        content.body = "What single sentence captures today?"
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: Constants.Notifications.identifier,
            content: content,
            trigger: trigger
        )
        
        try? await center.add(request)
    }
}