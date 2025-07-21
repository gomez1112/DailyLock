//
//  WeeklySummaryCard.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct WeeklySummaryCard: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Weekly AI Summary")
                    .font(.headline)
                    .foregroundStyle(colorScheme == .dark ? Color.darkInkColor : Color.lightInkColor)
                
                Spacer()
                
                Image(systemName: "sparkles")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            Text("This week you focused on family and personal growth. Your mood was predominantly positive with moments of reflection...")
                .font(.body)
                .foregroundStyle(.secondary)
                .lineLimit(3)
            
            Button {
                // Show full summary
            } label: {
                Text("Read Full Summary")
                    .font(.caption)
                    .fontWeight(.medium)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color.darkCardBackground : Color.lightCardBackground)
                .shadow(color: colorScheme == .dark ? Color.darkShadowColor : Color.lightShadowColor, radius: 10))
    }
}

#Preview {
    WeeklySummaryCard()
}
