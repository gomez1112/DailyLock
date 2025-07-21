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
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.body)
            Text(text)
                .font(.caption2)
        }
    }
}

#Preview {
    TrustBadge(icon: "crown", text: "Premium")
}
