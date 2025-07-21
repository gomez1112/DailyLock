//
//  LockedEntryView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct LockedEntryView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let entry: MomentumEntry
    @State private var appearAnimation = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Wax Seal
            WaxSeal(entry: entry)
                .frame(width: 80, height: 80)
                .scaleEffect(appearAnimation ? 1.0 : 0.5)
                .opacity(appearAnimation ? 1.0 : 0)
            
            // Entry Card
            VStack(spacing: 20) {
                Text(entry.text)
                    .font(.sentenceSerif)
                    .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.9) : Color(hex: entry.inkColor).opacity(0.9))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                Divider()
                    .overlay(Color((colorScheme == .dark ? Color.darkLineColor : Color.lightLineColor)))
                
                HStack(spacing: 20) {
                    HStack(spacing: 8) {
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
                        
                        Text(entry.sentiment.rawValue.capitalized)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    if let lockedAt = entry.lockedAt {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                            
                            Text(lockedAt.formatted(date: .omitted, time: .shortened))
                                .font(.system(size: 12, design: .monospaced))
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill((colorScheme == .dark ? Color.darkCardBackground : Color.lightCardBackground))
                    .shadow(color: (colorScheme == .dark ? Color.darkShadowColor : Color.lightShadowColor), radius: 10, y: 5)
            )
            .padding(.horizontal, 40)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                appearAnimation = true
            }
        }
    }
}

#Preview {
    LockedEntryView(entry: MomentumEntry.samples[0])
}
