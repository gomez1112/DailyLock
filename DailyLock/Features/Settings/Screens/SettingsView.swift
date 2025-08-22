//
//  SettingsView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

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
                ToolbarItem(placement: .automatic) {
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
                ToolbarSpacer()
                ToolbarItem(placement: .automatic) {
                    Button {
                        dependencies.syncedSetting.hasCompletedOnboarding = false
                    } label: {
                        Label("User Defaults", systemImage: "figure.surfing")
                    }
                }
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
}

#Preview(traits: .previewData) {
    SettingsView()
}
