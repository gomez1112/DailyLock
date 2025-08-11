//
//  TrustBadge.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct TrustBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.body)
                .accessibilityIdentifier("trustBadgeIcon")
            Text(text)
                .font(.caption2)
                .accessibilityIdentifier("trustBadgeText")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(text) icon")
        .accessibilityIdentifier("trustBadgeContainer")
    }
}

#Preview {
    TrustBadge(icon: "crown", text: "Premium")
}
