//
//  TipsView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI
import StoreKit

struct TipsView: View {
    @Environment(DataModel.self) private var model
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 16) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.pink)
                
                Text("Support DailyLock")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("If you love DailyLock, consider leaving a tip to support future development")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, horizontalSizeClass == .regular ? 100 : 40)
            }
            
            // Tip Options
            if !model.store.products.isEmpty {
                VStack(spacing: 16) {
                    if let smallTip = model.store.products.first(where: { $0.id == ProductID.smallTip }) {
                        TipProductView(product: smallTip, icon: "cup.and.saucer", title: "Coffee")
                            .onTapGesture {
                                
                            }
                    }
                    
                    if let mediumTip = model.store.products.first(where: { $0.id == ProductID.mediumTip }) {
                        TipProductView(product: mediumTip, icon: "takeoutbag.and.cup.and.straw", title: "Lunch")
                            .onTapGesture {
                                
                            }
                    }
                    
                    if let largeTip = model.store.products.first(where: { $0.id == ProductID.largeTip }) {
                        TipProductView(product: largeTip, icon: "gift", title: "Generous")
                            .onTapGesture {
                               
                            }
                    }
                }
                .padding(.horizontal, horizontalSizeClass == .regular ? 200 : 40)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding(40)
            }
            
            Text("Tips are one-time purchases that help support the app")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top)
        }
    }
}

#Preview(traits: .previewData) {
    TipsView()
}
