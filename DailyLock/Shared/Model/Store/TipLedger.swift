//
//  TipLedger.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import Foundation
import SwiftData
import os

struct TipPurchase {
    public let transactionId: UInt64
    public let productID: String
    public let productName: String
    public let amount: Decimal
    public let date: Date
}

@ModelActor
actor TipLedger {
    
    func record(_ purchase: TipPurchase) throws {
        
        let txId: UInt64 = purchase.transactionId
        
        let pred = #Predicate<TipRecord> { rec in
            rec.transactionId == txId
        }
        
        var fetch = FetchDescriptor<TipRecord>(predicate: pred)
        fetch.fetchLimit = 1
        
        if try modelContext.fetch(fetch).first != nil {
            Log.data.info("Transaction \(txId) already recorded. Skipping.")
            return // already recorded
        }
        
        let tip = TipRecord(
            transactionId: txId, date: purchase.date,
            amount: purchase.amount,
            productId: purchase.productID,
            productName: purchase.productName
        )
        modelContext.insert(tip)
        try modelContext.save()
        Log.data.info("Successfully recorded tip transaction \(txId).")
    }
}

