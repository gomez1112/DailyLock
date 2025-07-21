//
//  Store.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation
import StoreKit

@Observable
final class Store {
    private(set) var products: [Product] = []
    private(set) var purchasedProductIDs = Set<String>()
    
    var hasUnlockedPremium: Bool {
        !purchasedProductIDs.isEmpty
    }
    
    var monthlyProduct: Product? {
        products.first { $0.id == ProductID.monthlySubscription }
    }
    
    var yearProduct: Product? {
        products.first { $0.id == ProductID.yearlySubscription }
    }
    
    var lifetimeProduct: Product? {
        products.first { $0.id == ProductID.lifetimeUnlock }
    }
    
    private var updateListenerTask: Task<Void, Error>?
    
    init() {
        updateListenerTask = listenForTransactions()
        
        Task {
            await loadProducts()
            await updateCustomerProductStatus()
        }
    }
    
   isolated deinit { updateListenerTask?.cancel()}
    func loadProducts() async {
        do {
            let productIDs = [
                ProductID.monthlySubscription,
                ProductID.yearlySubscription,
                ProductID.lifetimeUnlock,
                ProductID.smallTip,
                ProductID.mediumTip,
                ProductID.largeTip
            ]
            
            products = try await Product.products(for: productIDs)
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updateCustomerProductStatus()
                await transaction.finish()
                return transaction
            case .userCancelled, .pending:
                return nil
            @unknown default:
                return nil
        }
    }
    func isPurchased(_ product: Product) async throws -> Bool {
        switch product.type {
            case .autoRenewable:
                return purchasedProductIDs.contains(product.id)
            case .nonConsumable:
                return purchasedProductIDs.contains(product.id)
            default:
                return false
        }
    }
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
            case .unverified:
                throw StoreError.failedVerification
            case .verified(let safe):
                return safe
        }
    }
    private func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                switch transaction.productType {
                    case .autoRenewable, .nonConsumable:
                        purchasedProductIDs.insert(transaction.productID)
                    default:
                        break
                }
                
                await transaction.finish()
            } catch {
                print("Transaction verification failed: \(error)")
            }
        }
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction listener error: \(error)")
                }
            }
        }
    }
}
