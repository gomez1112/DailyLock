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
            Link(destination: URL(string: "https://example.com/privacy")!) {
                Label("Privacy Policy", systemImage: "hand.raised")
                    .symbolRenderingMode(.hierarchical)
            }
            
            Link(destination: URL(string: "https://example.com/terms")!) {
                Label("Terms of Service", systemImage: "doc.text")
                    .symbolRenderingMode(.hierarchical)
            }
        }
    }
}

#Preview {
    LegalSection()
}
