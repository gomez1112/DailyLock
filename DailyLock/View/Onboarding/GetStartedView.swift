//
//  GetStartedView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/24/25.
//

import SwiftUI

struct GetStartedView: View {
    let onComplete: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: Constants.GetStarted.vStackSpacing) {
            Spacer()
            
            // Animated checkmarks
            VStack(spacing: Constants.GetStarted.checkmarkSpacing) {
                
                ForEach(0..<Constants.GetStarted.animatedCheckmarksCount, id: \.self) { index in
                    HStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.green)
                            .scaleEffect(isAnimating ? 1 : 0)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(
                                .spring().delay(Double(index) * Constants.GetStarted.checkmarkAnimationBaseDelay),
                                value: isAnimating
                            )
                        
                        Text(checkmarkText(for: index))
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(
                                .easeOut.delay(Double(index) * Constants.GetStarted.checkmarkAnimationBaseDelay + Constants.GetStarted.textOpacityDelay),
                                value: isAnimating
                            )
                    }
                    .accessibilityIdentifier("getStarted_checkmark_\(index)")
                }
            }
            .padding(.horizontal, Constants.GetStarted.horizontalPadding)
            
            VStack(spacing: 16) {
                Text("You're All Set!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .accessibilityIdentifier("getStarted_heading")
                    .accessibilityAddTraits(.isHeader)
                
                Text("Start capturing your first moment")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("getStarted_subtitle")
            }
            
            Spacer()
            
            Button {
                onComplete()
            } label: {
                HStack {
                    Text("Begin Writing")
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: Constants.GetStarted.buttonCornerRadius))
                .shadow(color: .blue.opacity(0.3), radius: Constants.GetStarted.buttonShadowRadius, y: Constants.GetStarted.buttonShadowYOffset)
            }
            .accessibilityIdentifier("getStarted_button")
            .accessibilityLabel("Begin Writing")
            .padding(.horizontal, Constants.GetStarted.horizontalPadding)
            .scaleEffect(isAnimating ? 1 : Constants.GetStarted.buttonScaleInactive)
            .opacity(isAnimating ? 1 : 0)
            .animation(.spring().delay(Constants.GetStarted.buttonSpringDelay), value: isAnimating)
            
            Spacer()
        }
        .padding(.horizontal, Constants.GetStarted.horizontalPadding)
        .onAppear {
            isAnimating = true
        }
    }
    
    private func checkmarkText(for index: Int) -> String {
        switch index {
        case 0: return "Daily journaling made simple"
        case 1: return "Your thoughts are private & secure"
        case 2: return "Build a meaningful habit"
        default: return ""
        }
    }
}

#Preview(traits: .previewData) {
    GetStartedView(onComplete: {})
}

