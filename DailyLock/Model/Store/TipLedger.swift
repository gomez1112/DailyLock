@ModelActor
actor TipLedger {
    /// Idempotent write; no-ops if this transaction was already recorded.
    func record(_ purchase: TipPurchase) throws {
        // Fast guard against duplicates
        let fetch = FetchDescriptor<TipRecord>(
            predicate: #Predicate { $0.transactionId == purchase.transactionId },
            fetchLimit: 1
        )
        if let _ = try modelContext.fetch(fetch).first {
            return // already recorded
        }

        let tip = TipRecord(
            date: purchase.date,
            amount: purchase.amount,
            productId: purchase.productID,
            productName: purchase.productName,
            transactionId: purchase.transactionId
        )
        modelContext.insert(tip)

        // If you rely on autosave you can omit this, but explicit save lets you catch uniqueness errors here.
        try modelContext.save()
    }
}