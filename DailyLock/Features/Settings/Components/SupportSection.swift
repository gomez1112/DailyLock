//
//  SupportSection.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/21/25.
//

import StoreKit
import SwiftUI

struct SupportSection: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        Section {
            Link(destination: URL(string: "mailto:gerard@transfinite.cloud")!) {
                Label {
                    Text("Contact Support")
                } icon: {
                    Image(systemName: "envelope")
                        .foregroundStyle(.accent)
                }
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("contactSupportLink")
            .accessibilityLabel("Contact Support")
            .accessibilityHint("Email the support team")
            
            Link(destination: URL(string: "https://transfinite.us/daily-lock/")!) {
                Label {
                    Text("Help Center")
                } icon: {
                    Image(systemName: "questionmark.circle")
                        .foregroundStyle(.accent)
                }
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("helpCenterLink")
            .accessibilityLabel("Help Center")
            .accessibilityHint("Open the online help center")
            
            Button {
                requestReview()
            } label: {
                Label {
                    Text("Rate DailyLock")
                } icon: {
                    Image(systemName: "star")
                        .foregroundStyle(.accent)
                }
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("rateDailyLockButton")
            .accessibilityLabel("Rate Daily Lock")
            .accessibilityHint("Leave a rating for DailyLock in the App Store")
        }
    }
}

#Preview {
    SupportSection()
}
