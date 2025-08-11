//
//  ConceptView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/24/25.
//

import SwiftUI

struct ConceptView: View {
    @State private var typewriterText = ""
    @State private var showLock = false
    
    @State private var fullText = "Today was perfect. Coffee with mom, sunset walk, grateful."
    
    var body: some View {
        VStack(spacing: AppSpacing.xLarge) {
            Spacer()
            
            // Visual demonstration
            ZStack {
                RoundedRectangle(cornerRadius: AppLayout.radiusXLarge)
                    .fill(.thinMaterial)
                    .frame(height: AppLayout.canvasHeight)
                
                VStack {
                    Text(typewriterText)
                        .font(.sentenceSerif)
                        .multilineTextAlignment(.center)
                        .padding()
                        .accessibilityIdentifier("conceptView_typewriterText")
                        .accessibilityLabel("Today's summary")
                        .accessibilityValue(typewriterText)
                    
                    if showLock {
                        Image(systemName: "lock.fill")
                            .font(.title)
                            .foregroundStyle(.accent)
                            .transition(.scale.combined(with: .opacity))
                            .accessibilityIdentifier("conceptView_lockIcon")
                            .accessibilityLabel("Locked")
                            .accessibilityHidden(!showLock)
                    }
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("conceptView_container")
            .frame(maxWidth: AppLayout.lockedEntryMaxWidth)
            
            VStack(spacing: AppSpacing.regular) {
                Text("One Sentence Daily")
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibilityIdentifier("conceptView_title")
                    .accessibilityLabel("One Sentence Daily")
                
                Text("Write what matters most today.\nLock it forever when ready.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .accessibilityIdentifier("conceptView_subtitle")
                    .accessibilityLabel("Write what matters most today. Lock it forever when ready.")
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            animateTypewriter()
        }
        .onDisappear {
            fullText = ""
        }
    }
    
    private func animateTypewriter() {
        for (index, character) in fullText.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * AppAnimation.delay) {
                typewriterText.append(character)
                
                if index == fullText.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + AppAnimation.standardDuration * 2) {
                        withAnimation(.spring()) {
                            showLock = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ConceptView()
}
