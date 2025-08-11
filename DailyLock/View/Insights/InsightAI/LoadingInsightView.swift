//
//  LoadingInsightView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/6/25.
//

import SwiftUI

struct LoadingInsightView: View {
    @Environment(\.isDark) private var isDark
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Generating Insights...")
                        .font(.headline)
                        .foregroundStyle(isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor)
                    
                    Text("Analyzing your week")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(0.8)
            }
            
            // Shimmer placeholders
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0..<3) { _ in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isDark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                        .frame(height: 16)
                        .placeholderShimmer()
                }
            }
        }
    }
}

#Preview {
    LoadingInsightView()
}
