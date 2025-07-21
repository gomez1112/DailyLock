//
//  ProductID.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation

enum ProductID {
    static let monthlySubscription = "com.dailylock.monthly"
    static let yearlySubscription = "com.dailylock.yearly"
    static let lifetimeUnlock = "com.dailylock.lifetime"
    
    // Tip Jar
    static let smallTip = "com.dailylock.tip.small"
    static let mediumTip = "com.dailylock.tip.medium"
    static let largeTip = "com.dailylock.tip.large"
    
    static var tips: [String] {
        [smallTip, mediumTip, largeTip]
    }
}
