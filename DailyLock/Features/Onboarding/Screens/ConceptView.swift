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
    
    private let fullText = "Today was perfect. Coffee with mom, sunset walk, grateful."
    
    var body: some View {
        OnboardingPageView {
            VStack {
                Text(typewriterText)
                    .font(.sentenceSerif)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(minHeight: 150, alignment: .top) // Ensure space
                
                if showLock {
                    Image(systemName: "lock.fill")
                        .font(.title)
                        .foregroundStyle(.accent)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(maxWidth: AppLayout.lockedEntryMaxWidth)
        } content: {
            VStack(spacing: AppSpacing.regular) {
                Text("One Sentence Daily")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Write what matters most today.\nLock it forever when ready.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .task {
            // ✅ This is the corrected, non-freezing animation logic
            await animateTypewriter()
        }
    }
    
    // ✅ This function is now async and uses Task.sleep
    private func animateTypewriter() async {
        for character in fullText {
            typewriterText.append(character)
            // Pause briefly between each character
            try? await Task.sleep(for: .milliseconds(50))
        }
        
        // Pause before showing the lock
        try? await Task.sleep(for: .seconds(1))
        withAnimation(.spring()) {
            showLock = true
        }
    }
}

#Preview {
    ConceptView()
}
