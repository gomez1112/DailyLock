//
//  PaywallView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import StoreKit
import SwiftUI

struct PaywallView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(DataModel.self) private var model
    
    @State private var selectedProduct: Product?
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            // Background
            PaperTextureView()
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    
                    // StoreKit Subscription View
                    if !model.store.products.isEmpty {
                        VStack(spacing: 20) {
                            Text("Choose Your Plan")
                                .font(.headline)
                                .foregroundStyle(colorScheme == .dark ? Color.darkInkColor : Color.lightInkColor)
                            
                            // Using StoreKit's native SubscriptionStoreView
                            SubscriptionStoreView(groupID: "4B7660B0") {
                                VStack {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 60))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .symbolEffect(.pulse)
                                    Text("DailyLock")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .fontDesign(.serif)
                                    Text("Turn daily sentences into personal insight")
                                        .font(.title3)
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                    // Features Grid
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                        ForEach(PremiumFeature.allCases, id: \.self) { feature in
                                            FeatureCard(feature: feature)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .subscriptionStoreControlStyle(.pagedProminentPicker)
                            .subscriptionStoreOptionGroupStyle(.tabs)
                            .storeButton(.visible, for: .restorePurchases)
                            .subscriptionStoreButtonLabel(.multiline)
                            .subscriptionStorePickerItemBackground(.thinMaterial)
                            .storeButton(.visible, for: .cancellation)
                            .onInAppPurchaseCompletion { _, result in
                                switch result {
                                    case .success(_):
                                        dismiss()
                                    case .failure(let error):
                                        errorMessage = error.localizedDescription
                                        showError = true
                                }
                            }
                            
                            // Lifetime Option
                            if let lifetime = model.store.lifetimeProduct {
                                VStack(spacing: 12) {
                                    Divider()
                                        .overlay(colorScheme == .dark ? Color.darkLineColor : Color.lightLineColor)
                                    
                                    Text("One-Time Purchase")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    #if !os(macOS)
                                    ProductView(id: lifetime.id) {
                                        Image(systemName: "infinity")
                                    }
                                    .productViewStyle(.large)
                                    .onInAppPurchaseCompletion { _, result in
                                        switch result {
                                            case .success(_):
                                                dismiss()
                                            case .failure(let error):
                                                errorMessage = error.localizedDescription
                                                showError = true
                                        }
                                    }
                                    #endif
                                }
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        // Loading state
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                            .padding(40)
                    }
                    
                    // Trust Badges
                    HStack(spacing: 24) {
                        TrustBadge(icon: "lock.shield", text: "Private & Secure")
                        TrustBadge(icon: "arrow.triangle.2.circlepath", text: "Cancel Anytime")
                        TrustBadge(icon: "star.fill", text: "4.9★ Rated")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 20)
                    
                    // Terms and Privacy
                    HStack(spacing: 16) {
                        Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
                        Text("•")
                        Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                        Text("•")
                        Link("Restore Purchases", destination: URL(string: "#")!)
                            .onTapGesture {
                                Task {
                                    do {
                                        try await AppStore.sync()
                                    } catch {
                                        errorMessage = "Restore failed: \(error.localizedDescription)"
                                        showError = true
                                    }
                                }
                            }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 40)
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        .task {
            await model.store.loadProducts()
        }
    }
}

#Preview(traits: .previewData) {
    PaywallView()
}
