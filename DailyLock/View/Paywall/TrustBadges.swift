//
//  TrustBadges.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/21/25.
//

import SwiftUI

struct TrustBadges: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                TrustBadge(icon: "lock.shield.fill", text: "Bank-level\nEncryption")
                TrustBadge(icon: "icloud.fill", text: "Secure\nSync")
                TrustBadge(icon: "hand.raised.fill", text: "Privacy\nFirst")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            
            Text("Cancel anytime • No questions asked")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .accessibilityIdentifier("trustSection")
    }
}

#Preview {
    TrustBadges()
}
