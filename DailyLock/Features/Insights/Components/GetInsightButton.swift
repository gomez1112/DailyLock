//
//  GetInsightButton.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/6/25.
//

import SwiftUI

struct GetInsightButton: View {
    let closure: () async throws -> Void
    
    var body: some View {
        Button {
            Task { @MainActor in
                try await closure()
            }
            
        } label: {
            Label("Generate Now", systemImage: "wand.and.stars")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(.accent.gradient)
                .clipShape(RoundedRectangle(cornerRadius: AppLayout.radiusMedium))
                .shadow(color: Color.accent.opacity(0.3), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
    }
}
