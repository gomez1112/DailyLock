//
//  SettingsView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import HealthKit
import SwiftData
import StoreKit
import SwiftUI

struct SettingsView: View {
    @Environment(\.isDark) private var isDark
    @Environment(\.modelContext) private var context
    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss
    
    @State private var showManageSubscription = false
    @State private var showHealthInsights = false
    @State private var isSyncingHealth = false
    
    var body: some View {
        NavigationStack {
            Form {
                PremiumSection(showManageSubscription: $showManageSubscription)
                    .accessibilityIdentifier("premiumSection")
                    .accessibilityElement(children: .contain)
                
                enhancedHealthKitSection
                
                GracePeriodSection()
                    .accessibilityIdentifier("gracePeriodSection")
                    .accessibilityElement(children: .contain)
                
                NotificationSection()
                    .accessibilityIdentifier("notificationSection")
                    .accessibilityElement(children: .contain)
                
                Section {
                    Button {
                        dependencies.navigation.presentedSheet = .tips
                    } label: {
                        Label {
                            Text("Show Tips")
                                .accessibilityLabel("Show Tips")
                        } icon: {
                            Image(systemName: "lightbulb")
                                .foregroundStyle(.accent)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("showTipsButton")
                    .accessibilityHint("Opens tips sheet")
                }
                .accessibilityElement(children: .contain)
                
                Section("Customization") {
                    Button {
                        dependencies.navigation.presentedSheet = .textureStoreView
                    } label: {
                        Label("Texture Store", systemImage: "photo.on.rectangle.angled")
                    }
                    .buttonStyle(.plain)
                }
                
                SupportSection()
                    .accessibilityIdentifier("supportSection")
                    .accessibilityElement(children: .contain)
                
                LegalSection()
                    .accessibilityIdentifier("legalSection")
                    .accessibilityElement(children: .contain)
                
                AboutSection(errorState: dependencies.errorState)
                    .accessibilityIdentifier("aboutSection")
                    .accessibilityElement(children: .contain)
            }
            .toolbar {
                Button(role: .destructive) {
                    do {
                        try context.delete(model: MomentumEntry.self)
                    } catch {
                        dependencies.errorState.show(DatabaseError.deleteFailed)
                    }
                    
                } label: {
                    Label("Delete All Data", systemImage: "trash")
                }
                .accessibilityIdentifier("deleteAllDataButton")
                .accessibilityLabel("Delete All Data")
                .accessibilityHint("Deletes all your entries.")
            }
            .scrollContentBackground(.hidden)
            .formStyle(.grouped)
            .navigationTitle("Settings")
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            
#if !os(macOS)
            .manageSubscriptionsSheet(isPresented: $showManageSubscription)
#endif
        }
    }
    
    // Enhanced HealthKit Section with more features
    private var enhancedHealthKitSection: some View {
        Section("Health Integration") {
            HStack {
                Label("Apple Health", systemImage: "heart.text.square.fill")
                    .foregroundStyle(.pink)
                
                Spacer()
                
                if let isAuthorized = dependencies.healthStore.isAuthorized {
                    if isAuthorized {
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                                Text("Connected")
                                    .font(.subheadline)
                                    .foregroundStyle(.green)
                            }
                            
                            if let lastSync = dependencies.healthStore.lastSyncDate {
                                Text("Synced \(lastSync.formatted(.relative(presentation: .named)))")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } else {
                        Button("Connect") {
                            Task {
                                _ = try? await dependencies.healthStore.requestAuthorization()
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(.pink)
                    }
                } else {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            
            // Additional Health Actions
            if dependencies.healthStore.isAuthorized == true {
                // Sync button
                Button {
                    Task {
                        await syncWithHealth()
                    }
                } label: {
                    Label {
                        HStack {
                            Text("Sync Now")
                            Spacer()
                            if isSyncingHealth {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else if dependencies.healthStore.syncedEntriesCount > 0 {
                                Text("\(dependencies.healthStore.syncedEntriesCount) entries")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } icon: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundStyle(.accent)
                            .symbolEffect(.rotate, value: isSyncingHealth)
                    }
                }
                .disabled(isSyncingHealth)
                
                // Health permissions
                Button {
#if !os(macOS)
                    if let url = URL(string: "x-apple-health://") {
                        openURL(url)
                    }
#endif
                } label: {
                    Label {
                        Text("Manage Permissions")
                    } icon: {
                        Image(systemName: "gear")
                            .foregroundStyle(.secondary)
                    }
                }
                .foregroundStyle(.secondary)
            }
        }
    }
    
    private func syncWithHealth() async {
        isSyncingHealth = true
        
        do {
            let entries = try dependencies.dataService.fetchAllEntries()
            try await dependencies.healthStore.syncEntries(entries)
            dependencies.haptics.success()
        } catch {
            dependencies.errorState.show(error as? AppError ?? DatabaseError.loadFailed)
        }
        
        isSyncingHealth = false
    }
}

#Preview(traits: .previewData) {
    SettingsView()
}
