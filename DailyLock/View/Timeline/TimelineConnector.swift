//
//  TimelineConnector.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct TimelineConnector: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        HStack(spacing: 20) {
            Rectangle()
                .fill((colorScheme == .dark ? Color.darkLineColor : Color.lightLineColor))
                .frame(width: 1, height: 30)
                .padding(.leading, 25)
            
            Spacer()
        }
    }
}

#Preview {
    TimelineConnector()
}
