//
//  LockedEntryView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI
struct LockedEntryView: View {
 
    @Environment(\.isDark) private var isDark
    
    @State private var appearAnimation = false
    
    let entry: MomentumEntry

    var body: some View {
        VStack(spacing: AppEntry.cardVerticalSpacing) {
            // Wax Seal
            WaxSeal(entry: entry)
                .frame(width: AppLayout.waxSealSize, height: AppLayout.waxSealSize)
                .scaleEffect(appearAnimation ? 1.0 : 0.5)
                .opacity(appearAnimation ? 1.0 : 0)
                // Accessibility: Identifier and label for wax seal
                .accessibilityIdentifier("waxSeal")
                .accessibilityLabel(Text("Wax seal for entry"))
            
           entryCard
        }
        
        .onAppear {
            withAnimation(.spring(response: AppAnimation.springResponse, dampingFraction: AppAnimation.springDamping).delay(AppAnimation.delay)) {
                appearAnimation = true
            }
        }
    }
    private var entryCard: some View {
        // Entry Card
        VStack(spacing: AppEntry.entryCardSpacing) {
            
            // Show title if present
            if !entry.title.isEmpty {
                Text(entry.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)
                    .accessibilityIdentifier("entryTitle")
            }
            
            entryText
            
            Divider()
                .overlay(Color((isDark ? ColorPalette.darkLineColor : ColorPalette.lightLineColor)))
            
            HStack(spacing: 20) {
                // Sentiment Section
                HStack(spacing: AppEntry.sentimentIconSpacing) {
                    Image(systemName: entry.sentiment.symbol)
                        .font(.system(size: DesignSystem.Text.Font.sentimentIcon))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(
                            LinearGradient(
                                colors: entry.sentiment.gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text(entry.sentiment.rawValue.capitalized)
                        .font(.system(size: DesignSystem.Text.Font.regular, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                // Accessibility: Identifier, label and value for sentiment section
                .accessibilityIdentifier("sentimentSection")
                .accessibilityLabel(Text("Sentiment"))
                .accessibilityValue(Text(entry.sentiment.rawValue.capitalized))
                
                if let lockedAt = entry.lockedAt {
                    // Lock Time Section
                    HStack(spacing: AppEntry.lockTimeIconSpacing) {
                        Image(systemName: "clock")
                            .font(.system(size: AppEntry.lockTimeFontSize))
                        
                        Text(lockedAt.formatted(date: .omitted, time: .shortened))
                            .font(.system(size: AppEntry.lockTimeFontSize, design: .monospaced))
                    }
                    .foregroundStyle(.secondary)
                    // Accessibility: Identifier, label and value for lock time section
                    .accessibilityIdentifier("lockTimeSection")
                    .accessibilityLabel(Text("Locked at"))
                    .accessibilityValue(Text(lockedAt.formatted(date: .omitted, time: .shortened)))
                }
            }
        }
        .padding(AppEntry.cardPadding)
        .cardBackground()
        .padding(.horizontal, AppEntry.cardHorizontalPadding)
        // Accessibility: Identifier and combine children for entry card
        .accessibilityIdentifier("entryCard")
        .accessibilityElement(children: .combine)
    }
    private var entryText: some View {
        Text(entry.detail)
            .font(.sentenceSerif)
            .foregroundStyle(isDark ? Color.white.opacity(0.9) : Color(hex: entry.inkColor)?.opacity(0.9) ?? .black)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            // Accessibility: Identifier and label for entry text
            .accessibilityIdentifier("entryText")
            .accessibilityLabel(Text("Entry text"))
    }
}

#Preview {
    LockedEntryView(entry: MomentumEntry.samples[1])
}

