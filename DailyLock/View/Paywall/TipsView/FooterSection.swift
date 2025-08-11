//
//  FooterSection.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import SwiftUI

struct FooterSection: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Tips are one-time purchases")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 20) {
                Image(systemName: "lock.shield.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("•")
                    .foregroundStyle(.tertiary)
                Text("Secure Payment")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text("•")
                    .foregroundStyle(.tertiary)
                Image(systemName: "checkmark.shield.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityIdentifier("footerSection")
    }
}

#Preview {
    FooterSection()
}
