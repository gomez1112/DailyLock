//
//  EntryDetailView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct EntryDetailView: View {
    
    @Environment(\.isDark) private var isDark
    @Environment(\.dismiss) private var dismiss
    
    @State private var appearAnimation = false
    
    let entry: MomentumEntry
    
    var entryEntity: MomentumEntryEntity {
        MomentumEntryEntity(from: entry)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(isDark ? ColorPalette.darkLineColor : ColorPalette.lightLineColor)
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: AppSpacing.large) {

                        dateHeader
                        entryContent
                    
                    }
                    .padding()
                }
                #if !os(macOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem {
                        Button(role: .close, action: dismiss.callAsFunction)
                            .accessibilityIdentifier("closeButton")
                    }
                }
            }
            .animation(.default, value: entry)
            .toolbar {
                ToolbarItem {
                    ShareLink(item: entryEntity, preview: entryEntity.sharePreview)
                }
            }
        }
        .accessibilityIdentifier("Entries-\(entry.id)")
        .onAppear {
            withAnimation(.spring(response: AppAnimation.springResponse, dampingFraction: AppAnimation.springDamping).delay(AppAnimation.delay)) {
                appearAnimation = true
            }
        }
    }
    private var entryBody: some View {
        Text(entry.text)
            .font(.sentenceSerif)
            .foregroundStyle(isDark ? Color.white : Color(hex: entry.inkColor) ?? .black)
            .multilineTextAlignment(.center)
            .padding(.horizontal, AppSpacing.large)
            .opacity(appearAnimation ? 1 : 0)
            .offset(y: appearAnimation ? 0 : 20)
            .accessibilityIdentifier("EntryDetailView-Body")
            .accessibilityLabel(entry.text)
            .accessibilityAddTraits(.isHeader)
    }
    private var entryContent: some View {
        // Entry Content
        VStack(spacing: AppSpacing.medium) {
            entryBody
            Divider()
                .overlay(isDark ? ColorPalette.darkLineColor : ColorPalette.lightLineColor)
                .padding(.horizontal, AppSpacing.xxxLarge)
            // Metadata
            metadata
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: AppLayout.radiusMedium)
                .fill(isDark ? ColorPalette.darkCardBackground : ColorPalette.lightCardBackground)
        )
    }
    private var metadata: some View {
        HStack(alignment: .bottom ,spacing: AppSpacing.large) {
            VStack(spacing: AppSpacing.small) {
                
                Image(systemName: entry.sentiment.symbol)
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(
                        LinearGradient(
                            colors: entry.sentiment.gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text(entry.sentiment.rawValue.capitalized)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .accessibilityIdentifier("EntryDetailView-Sentiment")
            .accessibilityLabel("Sentiment")
            .accessibilityValue(entry.sentiment.rawValue.capitalized)

            VStack(spacing: AppSpacing.small) {
                Text("\(entry.wordCount)")
                    .monospaced()
                    .font(.title2)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundStyle(isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor)
                Text("words".capitalized)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(-1)
            }
            .accessibilityIdentifier("EntryDetailView-WordCount")
            .accessibilityLabel("Word Count")
            .accessibilityValue("\(entry.wordCount) words")

            if let lockedAt = entry.lockedAt {
                VStack(spacing: AppSpacing.small) {
                    Image(systemName: "lock.fill")
                        .font(.title2)
                        .foregroundStyle(Color(hex: "8B0000") ?? .black)
                    
                    Text(lockedAt.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .accessibilityIdentifier("EntryDetailView-LockInfo")
                .accessibilityLabel("Locked at")
                .accessibilityValue(lockedAt.formatted(date: .omitted, time: .shortened))
            }
        }
        .opacity(appearAnimation ? 1 : 0)
        .scaleEffect(appearAnimation ? 1 : 0.8)
        .accessibilityIdentifier("EntryDetailView-Metadata")
        .accessibilityElement(children: .contain)
    }
    private var dateHeader: some View {
        VStack {
            Text(entry.displayDate)
                .font(.dateScript)
                .foregroundStyle(isDark ? ColorPalette.darkLineColor : ColorPalette.lightLineColor)
            
            Text(entry.date.formatted(date: .complete, time: .omitted))
                .font(.caption)
                .foregroundStyle(.secondary)
                .tracking(1)
        }
        .accessibilityIdentifier("EntryDetailView-DateHeader")
        .accessibilityElement(children: .combine)
        .accessibilityLabel(entry.date.formatted(date: .complete, time: .omitted))
    }
}

#Preview {
    EntryDetailView(entry: MomentumEntry.samples[2])
}
