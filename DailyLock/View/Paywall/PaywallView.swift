//
//  PaywallView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//
import StoreKit
import SwiftUI

struct PaywallView: View {
    @Environment(\.deviceStatus) private var deviceStatus
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(AppDependencies.self) private var dependencies
  
    @State private var selectedFeatureIndex = 0
    @State private var animateHero = false
    @State private var animateFeatures = false
    @State private var animateTestimonials = false
    @State private var pulseAnimation = false
    
    var body: some View {
        SubscriptionStoreView(groupID: ProductID.subscriptionGroupID) {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero Section
                    heroSection
                        .padding(.top, deviceStatus == .compact ? 20 : 40)
                    
                    // Features Showcase
                    featuresShowcase
                        .padding(.top, 20)

                }
            }
            .containerBackground(for: .subscriptionStoreFullHeight) {
                ZStack {
                    PaperTextureView()
                    // Floating elements for depth
                    floatingElements
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("paywallViewRoot")
        .backgroundStyle(.clear)
        .subscriptionStoreControlStyle(.automatic)
        .subscriptionStoreButtonLabel(.automatic)
        .subscriptionStorePickerItemBackground(.thinMaterial)
        .storeButton(.visible, for: .policies)
#if os(iOS)
        .storeButton(.visible, for: .redeemCode)
#else
        .frame(width: 400, height: 550)
#endif
        .subscriptionStoreControlIcon { product, subscriptionInfo in
            Group {
                if product.id.contains("yearly") || product.id.contains("lifetime") {
                    ZStack {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.accent.gradient)
                            .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                        
                        if product.id.contains("yearly") {
                            Text("SAVE")
                                .font(.system(size: 8, weight: .black))
                                .offset(y: -20)
                                .rotationEffect(.degrees(-15))
                                .foregroundStyle(.orange)
                        }
                    }
                } else if product.id.contains("month") {
                    Image(systemName: "sparkles")
                        .foregroundStyle(.accent.gradient)
                } else {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.accent.gradient)
                }
            }
            .symbolVariant(.fill)
            .symbolEffect(.pulse, isActive: true)
        }
        .onInAppPurchaseCompletion { _, result in
            switch result {
                case .success(_):
                    dependencies.haptics.success()
                    dismiss()
                case .failure(_):
                    dependencies.haptics.tap()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: 24) {
            // Animated Icon
            ZStack {
                // Glow effect
                Circle()
                    .fill(.accent.gradient.opacity(0.2))
                    .frame(width: 160, height: 160)
                    .blur(radius: 20)
                    .scaleEffect(animateHero ? 1.2 : 0.8)
                
                // Wax seal inspired premium badge
                ZStack {
                    Circle()
                        .fill(.accent.gradient)
                        .frame(width: 100, height: 100)
                        .shadow(color: .accent.opacity(0.5), radius: 20, y: 5)
                    
                    Image(systemName: "crown.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(animateHero ? 0 : -10))
                        .scaleEffect(animateHero ? 1 : 0.5)
                }
                .scaleEffect(animateHero ? 1 : 0.5)
                .opacity(animateHero ? 1 : 0)
            }
            
            // Title and Subtitle
            VStack(spacing: 12) {
                Text("DailyLock+")
                    .font(.system(size: 42, weight: .bold, design: .serif))
                    .foregroundStyle(.accent.gradient)
                    .opacity(animateHero ? 1 : 0)
                    .offset(y: animateHero ? 0 : 20)
                
                Text("Transform moments into meaning")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .opacity(animateHero ? 1 : 0)
                    .offset(y: animateHero ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.2), value: animateHero)
                
                // Value proposition
                Text("Join thousands capturing life's essence, one sentence at a time")
                    .font(.body)
                    .foregroundStyle(colorScheme == .dark ? ColorPalette.darkInkColor.opacity(0.8) : ColorPalette.lightInkColor.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .opacity(animateHero ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.3), value: animateHero)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("paywallHeroSection")
    }
    
    // MARK: - Features Showcase
    private var featuresShowcase: some View {
        VStack(spacing: 20) {
            // Feature Cards Carousel
            TabView(selection: $selectedFeatureIndex) {
                ForEach(Array(PremiumFeature.allCases.enumerated()), id: \.element) { index, feature in
                    FeatureShowcaseCard(feature: feature, isAnimated: animateFeatures)
                        .tag(index)
                        .scaleEffect(selectedFeatureIndex == index ? 1 : 0.95)
                        .opacity(selectedFeatureIndex == index ? 1 : 0.7)
                }
            }
            #if !os(macOS)
            .tabViewStyle(.page(indexDisplayMode: .never))
            #endif
            .frame(height: deviceStatus == .compact ? 280 : 320)
            .onChange(of: selectedFeatureIndex) { _, _ in
                dependencies.haptics.select()
            }
            
            // Custom Page Indicator
            HStack(spacing: 8) {
                ForEach(0..<PremiumFeature.allCases.count, id: \.self) { index in
                    Circle()
                        .fill(selectedFeatureIndex == index ? Color.accent : Color.secondary.opacity(0.3))
                        .frame(width: selectedFeatureIndex == index ? 12 : 8, height: 8)
                        .scaleEffect(selectedFeatureIndex == index ? 1 : 0.8)
                        .animation(.spring(response: 0.3), value: selectedFeatureIndex)
                }
            }
        }
        .accessibilityIdentifier("featuresShowcase")
    }
    
    // MARK: - Social Proof Section
    private var socialProofSection: some View {
        VStack(spacing: 20) {
            // Stats
            HStack(spacing: 30) {
                StatBadge(
                    number: "50K+",
                    label: "Writers",
                    icon: "person.3.fill",
                    isAnimated: animateTestimonials
                )
                
                StatBadge(
                    number: "1M+",
                    label: "Entries",
                    icon: "doc.text.fill",
                    isAnimated: animateTestimonials
                )
                
                StatBadge(
                    number: "4.9★",
                    label: "Rating",
                    icon: "star.fill",
                    isAnimated: animateTestimonials
                )
            }
            .padding(.horizontal, 40)
            
            // Testimonial
            TestimonialCard(isAnimated: animateTestimonials)
                .padding(.horizontal, 20)
        }
        .accessibilityIdentifier("socialProofSection")
    }
    // MARK: - Floating Elements
    private var floatingElements: some View {
        ZStack {
            // Floating journal pages
            ForEach(0..<3) { index in
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorScheme == .dark ? ColorPalette.darkCardBackground.opacity(0.3) : ColorPalette.lightCardBackground.opacity(0.3))
                    .frame(width: 60, height: 80)
                    .rotationEffect(.degrees(Double.random(in: -15...15)))
                    .offset(
                        x: index == 0 ? -120 : (index == 1 ? 140 : 0),
                        y: index == 0 ? -200 : (index == 1 ? -100 : -300)
                    )
                    .opacity(animateHero ? 0.5 : 0)
                    .animation(
                        .easeOut(duration: 1.5)
                        .delay(Double(index) * 0.2),
                        value: animateHero
                    )
            }
        }
        .allowsHitTesting(false)
    }
    
    // MARK: - Animations
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1)) {
            animateHero = true
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
            animateFeatures = true
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5)) {
            animateTestimonials = true
        }
        
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            pulseAnimation = true
        }
    }
}

