//
//  LegalSection.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/21/25.
//

import SwiftUI

struct LegalSection: View {
    var body: some View {
        Section {
            Link(destination: URL(string: "https://transfinite.us/policies/Privacy/")!) {
                Label {
                    Text("Privacy Policy")
                        .accessibilityIdentifier("privacyPolicyLabel")
                } icon: {
                    Image(systemName: "hand.raised")
                        .foregroundStyle(.accent)
                }
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("privacyPolicyLink")
            .accessibilityLabel("Open Privacy Policy")
            .accessibilityHint("Opens the privacy policy in your browser")
            .accessibilityElement()
            Link(destination: URL(string: "https://transfinite.us/policies/TermOfService/")!) {
                Label {
                    Text("Terms of Service")
                        .accessibilityIdentifier("termsOfServiceLabel")
                } icon: {
                    Image(systemName: "doc.text")
                        .foregroundStyle(.accent)
                }
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("termsOfServiceLink")
            .accessibilityLabel("Open Terms of Service")
            .accessibilityHint("Opens the terms of service in your browser")
            .accessibilityElement()
        }
    }
}

#Preview {
    LegalSection()
}
