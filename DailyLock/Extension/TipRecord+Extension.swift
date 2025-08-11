//
//  TipRecord+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/3/25.
//

import Foundation

@MainActor
extension TipRecord {
    static let sampleTips = [
        TipRecord(transactionId: 1, date: Date().addingTimeInterval(-86400 * 5), amount: 3, productId: ProductID.smallTip, productName: "Small Tip"),
        TipRecord(transactionId: 2, date: Date().addingTimeInterval(-86400 * 3), amount: 5, productId: ProductID.mediumTip, productName: "Medium Tip"),
        TipRecord(transactionId: 3, date: Date().addingTimeInterval(-86400 * 1), amount: 10, productId: ProductID.largeTip, productName: "Large Tip"),
        TipRecord(transactionId: 4, date: Date(), amount: 5, productId: ProductID.mediumTip, productName: "Medium Tip")
    ]
}
