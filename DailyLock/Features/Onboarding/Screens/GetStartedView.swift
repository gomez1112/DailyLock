//
//  GetStartedView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/24/25.
//
//

import SwiftUI

struct GetStartedView: View {
    let onComplete: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        
        OnboardingPageView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Your new daily habit is ready.")
                    .font(.system(size: 44, weight: .bold, design: .serif))
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(0..<3, id: \.self) { index in
                        HStack(spacing: 16) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                                .foregroundStyle(.green)
                            
                            Text(checkmarkText(for: index))
                                .font(.title3)
                        }
                        .scaleEffect(isAnimating ? 1 : 0.8)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring(dampingFraction: 0.7).delay(Double(index) * 0.15), value: isAnimating)
                    }
                }
                .padding(.horizontal)
            }
            .padding(40)
            
        } content: {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("You're All Set!")
                        .font(.largeTitle.weight(.bold))
                    
                    Text("Start capturing your first moment. A beautiful journey awaits.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeIn.delay(0.4), value: isAnimating)
                
                Button {
                    onComplete()
                } label: {
                    HStack {
                        Text("Begin Writing")
                        Image(systemName: "arrow.right")
                    }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .accentColor.opacity(0.4), radius: 10, y: 5)
                    
                }
                .buttonStyle(.plain)
                .scaleEffect(isAnimating ? 1 : 0.8)
                .opacity(isAnimating ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.5), value: isAnimating)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    private func checkmarkText(for index: Int) -> String {
        switch index {
            case 0: return "Journaling made simple"
            case 1: return "Private and secure"
            case 2: return "A meaningful habit"
            default: return ""
        }
    }
}
//import SwiftUI
//
//struct GetStartedView: View {
//    let onComplete: () -> Void
//    @State private var isAnimating = false
//    
//    var body: some View {
//        
//        OnboardingPageView {
//            VStack(spacing: Constants.GetStarted.checkmarkSpacing) {
//                
//                ForEach(0..<Constants.GetStarted.animatedCheckmarksCount, id: \.self) { index in
//                    HStack(spacing: 16) {
//                        Image(systemName: "checkmark.circle.fill")
//                            .font(.title2)
//                            .foregroundStyle(.green)
//                            .scaleEffect(isAnimating ? 1 : 0)
//                            .opacity(isAnimating ? 1 : 0)
//                            .animation(
//                                .spring().delay(Double(index) * Constants.GetStarted.checkmarkAnimationBaseDelay),
//                                value: isAnimating
//                            )
//                        
//                        Text(checkmarkText(for: index))
//                            .font(.body)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .opacity(isAnimating ? 1 : 0)
//                            .animation(
//                                .easeOut.delay(Double(index) * Constants.GetStarted.checkmarkAnimationBaseDelay + Constants.GetStarted.textOpacityDelay),
//                                value: isAnimating
//                            )
//                    }
//                    .accessibilityIdentifier("getStarted_checkmark_\(index)")
//                }
//                Spacer()
//            }
//            .padding(.horizontal, Constants.GetStarted.horizontalPadding)
//        } content: {
//            VStack(spacing: Constants.GetStarted.vStackSpacing) {
//                
//                VStack(spacing: 16) {
//                    Text("You're All Set!")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .accessibilityIdentifier("getStarted_heading")
//                        .accessibilityAddTraits(.isHeader)
//                    
//                    Text("Start capturing your first moment")
//                        .font(.body)
//                        .foregroundStyle(.secondary)
//                        .accessibilityIdentifier("getStarted_subtitle")
//                }
//                
//                Button {
//                    onComplete()
//                } label: {
//                    HStack {
//                        Text("Begin Writing")
//                        Image(systemName: "arrow.right")
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(.accent)
//                    .foregroundStyle(.white)
//                    .clipShape(RoundedRectangle(cornerRadius: Constants.GetStarted.buttonCornerRadius))
//                    .shadow(color: .blue.opacity(0.3), radius: Constants.GetStarted.buttonShadowRadius, y: Constants.GetStarted.buttonShadowYOffset)
//                    
//                }
//                .buttonStyle(.plain)
//                .accessibilityIdentifier("getStarted_button")
//                .accessibilityLabel("Begin Writing")
//                .scaleEffect(isAnimating ? 1 : Constants.GetStarted.buttonScaleInactive)
//                .opacity(isAnimating ? 1 : 0)
//                .animation(.spring().delay(Constants.GetStarted.buttonSpringDelay), value: isAnimating)
//              
//            }
//            .onAppear {
//                isAnimating = true
//            }
//        }
//    }
//    
//    private func checkmarkText(for index: Int) -> String {
//        switch index {
//        case 0: return "Daily journaling made simple"
//        case 1: return "Your thoughts are private & secure"
//        case 2: return "Build a meaningful habit"
//        default: return ""
//        }
//    }
//}

#Preview(traits: .previewData) {
    GetStartedView(onComplete: {})
}

