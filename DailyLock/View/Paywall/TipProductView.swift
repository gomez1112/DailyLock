//
//  TipProductView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import StoreKit
import SwiftUI

struct TipProductView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    let product: Product
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.pink)
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(colorScheme == .dark ? Color.darkInkColor : Color.lightInkColor)
                
                Text(product.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(product.displayPrice)
                .font(.headline)
                .foregroundStyle(.primary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color.darkCardBackground : Color.lightCardBackground)
                .shadow(color: colorScheme == .dark ? Color.darkShadowColor : Color.lightShadowColor, radius: 4)
        )
    }
}


