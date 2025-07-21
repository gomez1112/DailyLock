//
//  WritingPaper.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct WritingPaper: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    static let lineSpacing: CGFloat = 32
    static let topPadding: CGFloat = 45
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Paper background
                RoundedRectangle(cornerRadius: 20)
                    .fill((colorScheme == .dark ? Color.darkCardBackground : Color.lightCardBackground))
                    .shadow(color: (colorScheme == .dark ? Color.darkShadowColor : Color.lightShadowColor), radius: 10, y: 5)
                
                // Ruled lines
                VStack(alignment: .leading, spacing: WritingPaper.lineSpacing) {
                    ForEach(0..<7, id: \.self) { _ in
                        Rectangle()
                            .fill((colorScheme == .dark ? Color.darkLineColor : Color.lightLineColor))
                            .frame(height: 1)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, WritingPaper.topPadding)
                
                // Red margin line
                HStack {
                    Rectangle()
                        .fill(Color.red.opacity(0.3))
                        .frame(width: 1)
                        .padding(.leading, 35)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    WritingPaper()
}
