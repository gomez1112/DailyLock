//
//  ProductID.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation

/// A namespace containing all product identifiers and related metadata for in-app purchases.
///
/// `ProductID` centralizes the identifiers used for subscriptions, lifetime unlock, and tip jar
/// purchases, as well as grouping and icon mapping utilities.
///
/// - Note: All product IDs should be registered and managed through App Store Connect.
enum ProductID {
    static let weeklySubscription = "com.dailylock.weekly"
    static let monthlySubscription = "com.dailylock.monthly"
    static let yearlySubscription = "com.dailylock.yearly"
    static let lifetimeUnlock = "com.dailylock.lifetime"
    static let subscriptionGroupID = "4B7660B0"
    // Tip Jar
    static let smallTip = "com.dailylock.tip.small"
    static let mediumTip = "com.dailylock.tip.medium"
    static let largeTip = "com.dailylock.tip.large"
    
    //Texture Products
    static let brownTexture = "com.dailylock.brown.texture"
    static let vintageTexture = "com.dailylock.vintage.texture"
    static let scientificTexture = "com.dailylock.scientific.texture"
    static let waterColorStainedTexture = "com.dailylock.watercolorstained.texture"
    
    static let textures: [String] = [brownTexture, vintageTexture, scientificTexture, waterColorStainedTexture]
    static let tips: [String] =  [smallTip, mediumTip, largeTip]
    static let subscriptions: [String] = [ weeklySubscription, monthlySubscription, yearlySubscription ]
    static let all = tips + subscriptions + [lifetimeUnlock] + textures
    
    static let tipIcons: [String: String] = [
        smallTip: "cup.and.saucer",
        mediumTip: "takeoutbag.and.cup.and.straw",
        largeTip: "gift"
    ]
    static func texturePreviews(isDark: Bool) -> [String: String] {
        [ brownTexture: isDark ? "brownDarkTexture" : "brownLightTexture",
          vintageTexture: isDark ? "vintageDarkTexture" : "vintageLightTexture",
          scientificTexture: isDark ? "scientificDarkTexture" : "scientificLightTexture",
          waterColorStainedTexture: isDark ? "watercolor-StainedDarkTexture" : "watercolor-StainedLightTexture"
        ]
    }
}
