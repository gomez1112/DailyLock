//
//  View+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

extension View {
    func placeholderShimmer() -> some View {
        self
            .redacted(reason: .placeholder)
            .shimmering()
    }
    
    func shimmering() -> some View {
        modifier(Shimmer())
    }
    func tagStyle() -> some View {
        modifier(TagStyleModifier())
    }
    func premiumFeature(_ feature: PremiumFeature, isLocked: Bool) -> some View {
        modifier(PremiumFeatureModifier(isLocked: isLocked, feature: feature))
    }
    
    func cardBackground(cornerRadius: CGFloat = AppLayout.radiusLarge, shadowRadius: CGFloat = AppLayout.radiusSmall) -> some View {
        modifier(CardBackgroundModifier(cornerRadius: cornerRadius, shadowRadius: shadowRadius))
    }
    func withErrorHandling() -> some View {
        modifier(ErrorAlertModifier())
    }
    
    func trackDeviceStatus() -> some View {
        modifier(GetSizeClassModifier())
    }
    /// Apply a transform only if `condition` is true.
    @ViewBuilder
    func applyIf<Content: View>(_ condition: Bool, _ transform: (Self) -> Content) -> some View {
        if condition { transform(self) } else { self }
    }
    
    /// Platform-specific transform(s) in one place.
    @ViewBuilder
    func onPlatform<Content: View>(
        iOS: ((Self) -> Content)? = nil,
        macOS: ((Self) -> Content)? = nil,
        tvOS: ((Self) -> Content)? = nil,
        watchOS: ((Self) -> Content)? = nil,
        visionOS: ((Self) -> Content)? = nil
    ) -> some View {
#if os(iOS)
        if let iOS { iOS(self) } else { self }
#elseif os(macOS)
        if let macOS { macOS(self) } else { self }
#elseif os(tvOS)
        if let tvOS { tvOS(self) } else { self }
#elseif os(watchOS)
        if let watchOS { watchOS(self) } else { self }
#elseif os(visionOS)
        if let visionOS { visionOS(self) } else { self }
#endif
    }
    
    /// Platform value selector (returns iOS by default).
    func platformValue<V>(
        iOS: @autoclosure () -> V,
        macOS: @autoclosure () -> V? = nil,
        tvOS: @autoclosure () -> V? = nil,
        watchOS: @autoclosure () -> V? = nil,
        visionOS: @autoclosure () -> V? = nil
    ) -> V {
#if os(macOS)
        return macOS() ?? iOS()
#elseif os(tvOS)
        return tvOS() ?? iOS()
#elseif os(watchOS)
        return watchOS() ?? iOS()
#elseif os(visionOS)
        return visionOS() ?? iOS()
#else
        return iOS()
#endif
    }
    
    // --- Static Platform Checks ---
    
    static var isIOS: Bool {
#if os(iOS)
        true
#else
        false
#endif
    }
    static var isMacOS: Bool {
#if os(macOS)
        true
#else
        false
#endif
    }
    static var isTV: Bool {
#if os(tvOS)
        true
#else
        false
#endif
    }
    static var isWatch: Bool {
#if os(watchOS)
        true
#else
        false
#endif
    }
    static var isVision: Bool {
#if os(visionOS)
        true
#else
        false
#endif
    }
    
    static var isMobile: Bool {
#if os(iOS) || os(visionOS)
        true
#else
        false
#endif
    }
}

