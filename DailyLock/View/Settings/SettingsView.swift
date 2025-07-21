//
//  SettingsView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import StoreKit
import SwiftUI

struct SettingsView: View {
    @Environment(DataModel.self) private var model
    @Environment(\.requestReview) var requestReview
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("notificationTime") private var notificationTime = Date()
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    
    @State private var isShowingNotificationError = false
    @State private var showPaywall = false
    @State private var showManageSubscription = false
    
    var body: some View {
        NavigationStack {
            Form {
                // Premium Section
                Section {
                    if model.store.hasUnlockedPremium {
                        HStack {
                            Label {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("DailyLock+ Active")
                                        .font(.body)
                                    Text("Premium features unlocked")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            } icon: {
                                Image(systemName: "sparkles")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                            
                            
                            Spacer()
                            
                            Button("Manage") {
                                showManageSubscription = true
                            }
                            .font(.caption)
                            .buttonStyle(.bordered)
                        }
                    } else {
                        Button {
                            showPaywall = true
                        } label: {
                            HStack {
                                Label {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Upgrade to DailyLock+")
                                            .font(.body)
                                        Text("Unlock insights, themes & more")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                } icon: {
                                    Image(systemName: "sparkles")
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            
                        }
                        
                        .foregroundStyle(.primary)
                    }
                }
                
                // Notifications Section
                Section {
                    Toggle(isOn: $notificationsEnabled) {
                        Label {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Daily Reminder")
                                    .font(.body)
                                Text("A gentle nudge to capture today")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: "bell.badge")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.orange)
                        }
                    }
                    .tint(.orange)
                    .onChange(of: notificationsEnabled) { _, newValue in
                        updateNotification()
                    }
                    
                    if notificationsEnabled {
                        DatePicker(selection: $notificationTime, displayedComponents: .hourAndMinute) {
                            Label("Time", systemImage: "clock")
                                .symbolRenderingMode(.hierarchical)
                        }
                        .onChange(of: notificationTime) { _, _ in
                            updateNotification()
                        }
                    }
                }
                
                // Support Section
                Section {
                    Link(destination: URL(string: "mailto:support@example.com")!) {
                        Label("Contact Support", systemImage: "envelope")
                            .symbolRenderingMode(.hierarchical)
                    }
                    
                    Link(destination: URL(string: "https://example.com/help")!) {
                        Label("Help Center", systemImage: "questionmark.circle")
                            .symbolRenderingMode(.hierarchical)
                    }
                    
                    Button {
                        requestReview()
                    } label: {
                        Label("Rate DailyLock", systemImage: "star")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .buttonStyle(.plain)
                }

                
                // Legal Section
                Section {
                    Link(destination: URL(string: "https://example.com/privacy")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                            .symbolRenderingMode(.hierarchical)
                    }
                    
                    Link(destination: URL(string: "https://example.com/terms")!) {
                        Label("Terms of Service", systemImage: "doc.text")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                
                // About Section
                Section {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                            .symbolRenderingMode(.hierarchical)
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    
                    // Restore Purchases
                    Button {
                        Task {
                            try? await AppStore.sync()
                        }
                    } label: {
                        Label("Restore Purchases", systemImage: "arrow.clockwise")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background {
                PaperTextureView()
                    .ignoresSafeArea()
            }
            .formStyle(.grouped)
            .navigationTitle("Settings")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .alert("Oops!", isPresented: $isShowingNotificationError) {
                Button("Check Settings", action: showAppSettings)
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Allow notifications to receive your daily writing reminder.")
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
               // MinimalPaywallView()
            }
            #if !os(macOS)
            .manageSubscriptionsSheet(isPresented: $showManageSubscription)
            #endif
        }
    }
    
    private func updateNotification() {
        model.removeNotification()
        Task {
            if notificationsEnabled {
                let success = await model.addNotification(for: notificationTime)
                
                if !success {
                    notificationsEnabled = false
                    isShowingNotificationError = true
                }
            }
        }
    }
    
    private func showAppSettings() {
        #if !os(macOS)
        guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else { return }
        openURL(settingsURL)
        #endif
    }
}

#Preview(traits: .previewData) {
    SettingsView()
}

struct MinimalPaywallView: View {
    var body: some View {
        SubscriptionStoreView(groupID: "4B7660B0") {
            VStack(spacing: 16) {
                Image(systemName: "sparkles")
                    .font(.largeTitle)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.orange)
                
                Text("DailyLock")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text("Turn daily sentences into personal insight")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .subscriptionStoreControlStyle(.pagedProminentPicker)
        .subscriptionStoreOptionGroupStyle(.tabs)
    }
}
