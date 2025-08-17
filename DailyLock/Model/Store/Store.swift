//
//  Store.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation
import StoreKit
import Observation
import os

typealias SubscriptionGroupID = String


@Observable
final class Store {
    private let tipLedger: TipLedger
    private let errorState: ErrorState
    
    private(set) var products: [Product] = []
    private(set) var purchasedProductIDs = Set<String>()
    private(set) var subscriptionStatuses: [SubscriptionGroupID: [SubscriptionStatus]] = [:]
    /// A computed property that returns only the texture products, sorted by price.
    var textureProducts: [Product] {
        products.filter { ProductID.textures.contains($0.id) }
            .sorted { $0.price < $1.price }
    }
    
    /// Checks if a product with the given ID has been purchased.
    func isPurchased(_ productID: String) -> Bool {
        purchasedProductIDs.contains(productID)
    }
    var hasUnlockedLifetime: Bool {
        purchasedProductIDs.contains(ProductID.lifetimeUnlock)
    }
    
    var hasUnlockedPremium: Bool {
        hasUnlockedLifetime || hasActiveSubscription
    }
    
    private var updateListenerTask: Task<Void, Error>?
    
    init(tipLedger: TipLedger, errorState: ErrorState) {
        self.tipLedger = tipLedger
        self.errorState = errorState
        updateListenerTask = listenForTransactions()
        
        Task {
            try await loadProducts()
            try await updateCustomerProductStatus()
            try await checkForUnfinishedTransactions()
        }
    }

    isolated deinit { updateListenerTask?.cancel() }
    
    func loadProducts() async throws {
        await Signpost.store.measure(name: "loadProducts") {
            do {
                products = try await Product.products(for: ProductID.all)
                Log.store.info("Successfully loaded \(self.products.count) products.")
            } catch {
                Log.store.error("Failed to load products: \(error.localizedDescription, privacy: .public)")
                errorState.showStoreError(.failedToLoadProducts)
            }
        }
    }

    var hasActiveSubscription: Bool {
        // Check the entitlements for active subscriptions
        guard let statuses = subscriptionStatuses[ProductID.subscriptionGroupID] else {
            return false
        }
        
        // Check if any subscription is active
        return statuses.contains { status in
            switch status.state {
                case .subscribed, .inBillingRetryPeriod, .inGracePeriod:
                    return true
                default:
                    return false
            }
        }
    }
    private func checkVerified<T>(_ result: VerificationResult<T>) async throws -> T {
        switch result {
            case .unverified:
                throw StoreError.verificationFailed
            case .verified(let safe):
                return safe
        }
    }

    private func updateCustomerProductStatus() async throws {
        try await Signpost.store.measure(name: "updateCustomerProductStatus") {
            
            // Reset purchased products to ensure an accurate state
            var updatedPurchasedProductIDs = Set<String>()
            
            // 1. Iterate through current entitlements for lifetime purchases
            for await result in Transaction.currentEntitlements {
                do {
                    let transaction = try await checkVerified(result)
                    
                    // Only handle the lifetime product here
                    if transaction.productType == .nonConsumable {
                        updatedPurchasedProductIDs.insert(transaction.productID)
                    }
                } catch {
                    Log.store.error("Transaction verification failed: \(error.localizedDescription, privacy: .public)")
                    errorState.showStoreError(.verificationFailed)
                }
            }
            
            // Update the set of purchased non-consumables
            self.purchasedProductIDs = updatedPurchasedProductIDs
            Log.store.debug("Updated purchased products. Count: \(self.purchasedProductIDs.count)")
            // 2. Fetch the latest subscription statuses
            // This will populate the dictionary your `hasActiveSubscription` property uses
            for try await (subscriptionGroupID, statuses) in SubscriptionStatus.all {
                self.subscriptionStatuses[subscriptionGroupID] = statuses
            }
            Log.store.debug("Updated subscription statuses.")
        }
    }
    
  
    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached { [weak self] in
            guard let self else { return }
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    try await self.fulfill(transaction)
                    try await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    Log.store.error("Transaction listener error: \(error.localizedDescription, privacy: .public)")
                    await errorState.showStoreError(.verificationFailed)
                }
            }
        }
    }
    private func fulfill(_ transaction: Transaction) async throws {
        do {
            switch transaction.productType {
                case .consumable:
                    // Tip Jar purchase
                    let productID = transaction.productID
                    let product = products.first { $0.id == productID }
                    
                    let purchase = TipPurchase(
                        transactionId: transaction.id,
                        productID: productID,
                        productName: product?.displayName ?? productID,
                        amount: product?.price ?? 0,
                        date: transaction.purchaseDate
                    )
                    try await tipLedger.record(purchase)
                case .nonConsumable:
                    // Lifetime unlock
                    purchasedProductIDs.insert(transaction.productID)
                    
                case .autoRenewable, .nonRenewable:
                    // Keep statuses fresh for subs
                    try await updateCustomerProductStatus()
                    
                default:
                    break
            }
        } catch {
            Log.store.error("Fullfillment error: \(error.localizedDescription, privacy: .public)")
            errorState.showStoreError(.purchaseFailed("Could not fulfill transaction"))
        }
    }
    private func checkForUnfinishedTransactions() async throws {
        for await result in Transaction.unfinished {
            do {
                let transaction = try await checkVerified(result)
                Log.store.debug("Found unfinished transaction: \(transaction.id)")
                try await fulfill(transaction)
                // The same logic as in updateCustomerProductStatus
                // can be used here, or you can just call it again.
                try await updateCustomerProductStatus()
                await transaction.finish()
            } catch {
                Log.store.error("Unfinished transaction verification failed: \(error.localizedDescription)")
                errorState.showStoreError(.productNotFound)
            }
        }
    }
}

