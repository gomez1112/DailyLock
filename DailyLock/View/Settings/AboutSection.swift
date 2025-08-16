//
//  AboutSection.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/21/25.
//

import StoreKit
import SwiftUI

struct AboutSection: View {
    
    let errorState: ErrorState
    
    var body: some View {
        Section {
            HStack {
                Label {
                    Text("Version")
                } icon: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.accent)
                }
                Spacer()
                Text("1.0.0")
                    .foregroundStyle(.secondary)
            }
            .accessibilityIdentifier("versionRow")
            .accessibilityElement(children: .combine)
            .accessibilityLabel("App Version")
            .accessibilityValue("1.0.0")
            
            // Restore Purchases
            Button {
                Task {
                    do {
                        try await AppStore.sync()
                    } catch {
                        errorState.showStoreError(.restorationFailed)
                    }
                }
            } label: {
                Label {
                    Text("Restore Purchases")
                } icon: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundStyle(.accent)
                }
            }
            .accessibilityIdentifier("restorePurchasesButton")
            .accessibilityLabel("Restore Purchases")
            .buttonStyle(.plain)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("aboutSection")
    }
}

#Preview(traits: .previewData) {
    AboutSection(errorState: ErrorState())
}
