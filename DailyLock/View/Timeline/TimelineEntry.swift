//
//  TimelineEntry.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct TimelineEntry: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let entry: MomentumEntry
    let isHovered: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            // Date Badge
            VStack(spacing: 4) {
                Text(entry.date.formatted(.dateTime.day()))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle((colorScheme == .dark ? Color.darkInkColor : Color.lightInkColor))
                
                Text(entry.date.formatted(.dateTime.weekday(.abbreviated)))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 50)
            
            // Entry Card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: entry.sentiment.symbol)
                        .font(.system(size: 14))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(
                            LinearGradient(
                                colors: entry.sentiment.gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Spacer()
                    
                    if entry.isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.tertiary)
                    }
                }
                
                Text(entry.text)
                    .font(.system(size: 15))
                    .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.8) : Color(hex: entry.inkColor).opacity(0.8))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text("\(entry.wordCount) words")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill((colorScheme == .dark ? Color.darkCardBackground : Color.lightCardBackground))
                    .shadow(
                        color: (colorScheme == .dark ? Color.darkShadowColor : Color.lightShadowColor).opacity(isHovered ? 0.2 : 0.1),
                        radius: isHovered ? 8 : 4,
                        y: isHovered ? 4 : 2
                    )
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .onTapGesture(perform: onTap)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    TimelineEntry(entry: MomentumEntry.samples[0], isHovered: true, onTap: {})

}
