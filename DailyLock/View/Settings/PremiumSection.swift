//
//  PremiumSection.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/21/25.
//

import StoreKit
import SwiftUI

struct PremiumSection: View {
    @Environment(AppDependencies.self) private var dependencies
    @Binding var showManageSubscription: Bool
    
    var body: some View {
        Section {
            if dependencies.store.hasUnlockedPremium {
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
                        Image(systemName: "crown")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.accent)
                    }
                    .accessibilityIdentifier("premiumActiveLabel")
                    .accessibilityLabel("DailyLock Plus active. Premium features unlocked.")
                    
                    Spacer()
                    
                    Button("Manage") {
                        showManageSubscription = true
                    }
                    .font(.caption)
                    .buttonStyle(.bordered)
                    .accessibilityIdentifier("manageSubscriptionButton")
                    .accessibilityLabel("Manage Subscription")
                }
                .accessibilityIdentifier("premiumActiveSection")
            } else {
                Button {
                    dependencies.navigation.presentedSheet = .paywall
                } label: {
                    HStack {
                        Label {
                            VStack(alignment: .leading) {
                                Text("Upgrade to DailyLock+")
                                    .font(.body)
                                Text("Unlock insights, themes & more")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: "crown")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.accent)
                        }
                        .accessibilityIdentifier("upgradeLabel")
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(.primary)
                .accessibilityIdentifier("upgradeButton")
                .accessibilityLabel("Upgrade to DailyLock Plus. Unlock insights, themes, and more.")
            }
        }
        .accessibilityElement(children: .contain)
    }
}

#Preview(traits: .previewData) {
    PremiumSection(showManageSubscription: .constant(false))
}
