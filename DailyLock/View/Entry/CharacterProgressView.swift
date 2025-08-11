//
//  CharacterProgressView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct CharacterProgressView: View {
    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.isDark) private var isDark
    
    let current: Int
    let limit: Int
    let progress: Double
    let progressColor: EntryViewModel.ProgressColorStyle  // Now passed in
    
    @State private var showWarning = false
    
    var body: some View {
        VStack {
            Gauge(value: progress, in: 0...1) {
                HStack {
                    Spacer()
                    Text("\(current)/\(limit)")
                        .contentTransition(.numericText(value: progress))
                        .animation(.default, value: progress)
                        .foregroundStyle(warningColor)
                        .accessibilityIdentifier("CharacterProgressText")
                }
            }
            .tint(color(for: progressColor))
            .accessibilityIdentifier("CharacterProgressGauge")
            
            if progress > 0.9 {
                Text("Approaching character limit")
                    .font(.caption2)
                    .foregroundStyle(.orange)
                    .transition(.opacity)
            } else if progress >= 1.0 {
                Text("Character limit reached")
                    .font(.caption2)
                    .foregroundStyle(.red)
                    .transition(.opacity)
            }
        }
        .accessibilityLabel("Character usage progress")
        .accessibilityValue("\(current) out of \(limit) characters used")
        .accessibilityElement(children: .combine)
        .onChange(of: progress) { _, newValue in
            if newValue > 0.9 && !showWarning {
                showWarning = true
                dependencies.haptics.warning()
            } else if newValue <= 0.9 {
                showWarning = false
            }
        }
    }
    
    private var warningColor: Color {
        if progress >= 1.0 {
            return .red
        } else if progress > 0.9 {
            return .orange
        } else {
            return isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor
        }
    }
    
    private func color(for style: EntryViewModel.ProgressColorStyle) -> Color {
        switch style {
            case .red: return .red
            case .orange: return .orange
            case .darkLine: return ColorPalette.darkLineColor
            case .lightLine: return ColorPalette.lightLineColor
        }
    }
}

#Preview(traits: .previewData) {
    CharacterProgressView(current: 170, limit: DesignSystem.Text.maxCharacterCount, progress: 0.95, progressColor: .darkLine)
}
