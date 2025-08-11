//
//  CustomPageIndicator.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/24/25.
//

import SwiftUI

struct CustomPageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack {
            ForEach(0..<totalPages, id: \.self) { page in
                Capsule()
                    .fill(page == currentPage ? Color.primary : Color.secondary.opacity(0.3))
                    .frame(width: page == currentPage ? 24 : 8, height: 8)
                    .animation(.spring(), value: currentPage)
            }
        }
    }
}

#Preview {
    CustomPageIndicator(currentPage: 6, totalPages: 10)
}
