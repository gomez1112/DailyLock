//
//  TipsOptionSection.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import SwiftData
import StoreKit
import SwiftUI

struct TipsOptionSection: View {
    @Environment(\.deviceStatus) private var deviceStatus
    @Environment(\.modelContext) private var context
    @Binding var purchasedTipName: String
    @Binding var purchasedTipAmount: Decimal
    
    @Environment(AppDependencies.self) private var dependencies
    
    @Binding var selectedTipIndex: Int?
    @Binding var showThankYou: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            if !dependencies.store.products.isEmpty {
                VStack(spacing: 16) {
                    ForEach(Array(ProductID.tips.enumerated()), id: \.element) { index, tipID in
                        ProductView(id: tipID) {
                            if let iconName = ProductID.tipIcons[tipID] {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: tipGradientColors(for: index),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: iconName)
                                        .font(.title3)
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                        .productViewStyle(.tipStyle)
                        .scaleEffect(selectedTipIndex == index ? 1.02 : 1)
                        .animation(.spring(response: 0.3), value: selectedTipIndex)
                        .onTapGesture {
                            selectedTipIndex = index
                            dependencies.haptics.tap()
                        }
                        .onInAppPurchaseCompletion { product, result in
                            switch result {
                                case .success(.success(let verificationResult)):
                                    switch verificationResult {
                                        case .verified(let transaction):
                                            purchasedTipName = product.displayName
                                            purchasedTipAmount = product.price

                                            showThankYou = true
                                            
                                            // Finish the transaction
                                            Task {
                                                await transaction.finish()
                                            }
                                        case .unverified(_, _):
                                            // Handle unverified transaction
                                            break
                                    }
                                case .success(.userCancelled):
                                    break
                                case .success(.pending):
                                    break
                                case .failure(_):
                                    break
                                @unknown default:
                                    break
                            }
                        }
                        .accessibilityIdentifier("tipOption_\(tipID)")
                    }
                }
                .padding(.horizontal, deviceStatus == .compact ? 20 : 60)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
                    .padding(60)
                    .accessibilityIdentifier("tipsLoadingIndicator")
            }
        }
        .padding(.top, 30)
        .accessibilityIdentifier("tipOptionsSection")
    }

    private func tipGradientColors(for index: Int) -> [Color] {
        switch index {
            case 0: return [Color(hex: "8B4513") ?? .black, Color(hex: "A0522D") ?? .black] // Coffee brown
            case 1: return [Color(hex: "FF6B6B") ?? .black, Color(hex: "FF8E53") ?? .black] // Warm orange
            case 2: return [Color(hex: "4ECDC4") ?? .black, Color(hex: "44A08D") ?? .black] // Premium teal
            default: return [.accent, .accent.opacity(0.8)]
        }
    }
}

#Preview {
    TipsOptionSection(purchasedTipName: .constant(""), purchasedTipAmount: .constant(0.0), selectedTipIndex: .constant(nil), showThankYou: .constant(true))
}
