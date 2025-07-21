//
//  EntryDetailView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct EntryDetailView: View {
    let entry: MomentumEntry
    @Environment(\.isDark) private var isDark
    @Environment(\.dismiss) private var dismiss
    
    @State private var appearAnimation = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(isDark ? Color.darkLineColor : Color.lightLineColor)
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 32) {

                        // Date Header
                        VStack(spacing: 12) {
                            Text(entry.displayDate)
                                .font(.dateScript)
                                .foregroundStyle(isDark ? Color.darkLineColor : Color.lightLineColor)
                            
                            Text(entry.date.formatted(date: .complete, time: .omitted))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .tracking(1)
                        }
                        .padding(.top, 40)
                        
                        
                        // Entry Content
                        VStack(spacing: 24) {
                            Text(entry.text)
                                .font(.sentenceSerif)
                                .foregroundStyle(isDark ? Color.white : Color(hex: entry.inkColor))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 20)
                            
                            Divider()
                                .overlay(isDark ? Color.darkLineColor : Color.lightLineColor)
                                .padding(.horizontal, 60)
                            
                            // Metadata
                            HStack(alignment: .bottom ,spacing: 32) {
                                VStack(spacing: 8) {
                                    
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
                                .alignmentGuide(.firstTextBaseline) { d in d[.firstTextBaseline] }
                                VStack(spacing: 8) {
                                    Text("\(entry.wordCount)")
                                        .monospaced()
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .fontDesign(.rounded)
                                        .foregroundStyle(isDark ? Color.darkInkColor : Color.lightInkColor)
                                    Text("words".capitalized)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .padding(-1)
                                }
                                .alignmentGuide(.firstTextBaseline) { d in d[.firstTextBaseline] }
                                if let lockedAt = entry.lockedAt {
                                    VStack(spacing: 8) {
                                        Image(systemName: "lock.fill")
                                            .font(.title2)
                                            .foregroundStyle(Color(hex: "8B0000"))
                                        
                                        Text(lockedAt.formatted(date: .omitted, time: .shortened))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .opacity(appearAnimation ? 1 : 0)
                            .scaleEffect(appearAnimation ? 1 : 0.8)
                        }
                        
                        Spacer(minLength: 50)
                    }
                }
                #if !os(macOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem {
                        Button(role: .close, action: dismiss.callAsFunction)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                appearAnimation = true
            }
        }
    }
}

#Preview {
    EntryDetailView(entry: MomentumEntry.samples[2])
}
