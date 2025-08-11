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
    
    @AppStorage("notificationTime") private var notificationTime = Date()
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    
    @State private var showManageSubscription = false
    
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
                
                SupportSection()
                    .accessibilityIdentifier("supportSection")
                    .accessibilityElement(children: .contain)
                
                LegalSection()
                    .accessibilityIdentifier("legalSection")
                    .accessibilityElement(children: .contain)
                
                AboutSection()
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
            .background {
                Image(isDark ? .brownDarkTexture : .brownLightTexture )
            }
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
