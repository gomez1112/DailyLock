//
//  TermsView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/21/25.
//

import StoreKit
import SwiftUI

struct TermsView: View {
    
    let errorState: ErrorState
    
    var body: some View {
        HStack(spacing: 16) {
            Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
            Text("•")
            Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
            Text("•")
            Button("Restore Purchases") {
                Task {
                    do {
                        try await AppStore.sync()
                    } catch {
                        errorState.showStoreError(.restorationFailed)
                    }
                }
            }
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.bottom)
    }
}

#Preview(traits: .previewData) {
    TermsView(errorState: ErrorState())
}
