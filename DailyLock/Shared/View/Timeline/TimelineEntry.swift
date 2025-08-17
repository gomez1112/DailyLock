//
//  TimelineEntry.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct TimelineEntry: View {
    @Environment(\.isDark) private var isDark
    
    let entry: MomentumEntry
    let isHovered: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: AppTimeline.entrySpacing) {
            dateBadge
            entryCard
        }
        .padding(.vertical, AppTimeline.verticalPadding)
        .contentShape(Rectangle())
        // Add an identifier here
        .accessibilityIdentifier("entryRow")
    }
    
    private var dateBadge: some View {
        VStack(spacing: 4) {
            Text(entry.date.formatted(.dateTime.day()))
                .font(.system(size: DesignSystem.Text.Font.timelineDate, weight: .bold, design: .rounded))
                .foregroundStyle(isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor)
            
            Text(entry.date.formatted(.dateTime.weekday(.abbreviated)))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: AppTimeline.dateBadgeWidth)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("dateBadge")
        .accessibilityLabel(Text("Date: \(entry.date.formatted(.dateTime.day())) (\(entry.date.formatted(.dateTime.weekday(.abbreviated))))"))
    }
    
    private var entryCard: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: entry.sentiment.symbol)
                    .font(.system(size: DesignSystem.Text.Font.timelineSentiment))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(
                        LinearGradient(
                            colors: entry.sentiment.gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .accessibilityIdentifier("sentimentIcon")
                    .accessibilityLabel(Text("Sentiment: \(entry.sentiment.accessibilityDescription)"))
                
                Spacer()
                
                if entry.isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: DesignSystem.Text.Font.timelineLock))
                        .foregroundStyle(.tertiary)
                        .accessibilityIdentifier("lockedIcon")
                        .accessibilityLabel(Text("Locked entry"))
                        .accessibilityHint(Text("This entry is private and locked."))
                }
            }
            
            Text(entry.text)
                // Use app-specific font size constant for timeline entry text
                .font(.system(size: DesignSystem.Text.Font.timelineEntryText))
                .foregroundStyle(isDark ? Color.white.opacity(AppTimeline.entryTextOpacity) : Color(hex: entry.inkColor) ?? .black.opacity(AppTimeline.entryTextOpacity))
                // Use app-specific line limit constant for timeline entry text
                .lineLimit(AppTimeline.entryTextLineLimit)
                .multilineTextAlignment(.leading)
                .accessibilityIdentifier("entryText")
            
            Text("\(entry.wordCount) words")
                .font(.caption)
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("wordCount")
                .accessibilityLabel(Text("Word count: \(entry.wordCount)"))
        }
        .padding(AppTimeline.entryCardPadding)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("entryCard")
        .accessibilityLabel(Text("Entry text: \(entry.text). Word count: \(entry.wordCount). \(entry.isLocked ? "This entry is locked." : "This entry is not locked.")"))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppPremium.cardCornerRadius)
                .fill(isDark ? ColorPalette.darkCardBackground : ColorPalette.lightCardBackground)
                .shadow(
                    color: shadowColor,
                    radius: shadowRadius,
                    // Use app-specific y-offset constants for the shadow when hovered or not
                    y: isHovered ? AppAnimation.pressedScale : AppAnimation.timelineHoveredScale
                )
        )
        .scaleEffect(isHovered ? AppAnimation.timelineHoveredScale : 1.0)
        .onTapGesture(perform: onTap)
#if os(macOS)
        .onHover { hovering in
            if hovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
#endif
    }
    
    private var shadowColor: Color {
        (isDark ? DesignSystem.Shadow.darkShadowColor : DesignSystem.Shadow.lightShadowColor).opacity(isHovered ? 0.2 : 0.1)
    }
    
    private var shadowRadius: CGFloat {
#if os(macOS)
        isHovered ? DesignSystem.Shadow.shadowRegular : DesignSystem.Shadow.shadowSmall
#else
        isHovered ? DesignSystem.Shadow.shadowRegular : DesignSystem.Shadow.shadowSmall
#endif
    }
}

#Preview {
    TimelineEntry(entry: MomentumEntry.samples[0], isHovered: true, onTap: {})
}
