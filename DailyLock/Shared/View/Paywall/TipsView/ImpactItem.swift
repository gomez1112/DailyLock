//
//  ImpactItem.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import SwiftUI

struct ImpactItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.accent)
            
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(.primary)
            
            Text(description)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ImpactItem(icon: "house", title: "House", description: "This is a very good house")
}
