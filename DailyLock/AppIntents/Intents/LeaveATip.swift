//
//  representing.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import AppIntents
import StoreKit
/// An enum representing the different tip sizes for the `LeaveATip` intent.
enum TipSize: String, AppEnum {
    case small, medium, large
    
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Tip Size"
    
    static let caseDisplayRepresentations: [TipSize: DisplayRepresentation] = [
        .small: "Small",
        .medium: "Medium",
        .large: "Large"
    ]
}

/// Initiates an in-app purchase to leave a tip.
struct LeaveATip: AppIntent {
    static let title: LocalizedStringResource = "Leave a Tip"
    static let description = IntentDescription("Supports the developer by leaving a tip.")
    
    @Parameter(title: "Tip Size")
    var size: TipSize
    
    @Dependency private var store: Store
    @Dependency private var errorState: ErrorState
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let productID: String
        switch size {
        case .small: productID = ProductID.smallTip
        case .medium: productID = ProductID.mediumTip
        case .large: productID = ProductID.largeTip
        }
        
        guard let product = store.products.first(where: { $0.id == productID }) else {
            errorState.showIntentError(.unavailableTips)
            throw IntentError.unavailableTips
        }
        
        _ = try await product.purchase()
        
        return .result(dialog: "Thank you so much for your support! It means the world.")
    }
}

