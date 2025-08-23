//
//  TimelineConnector.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct TimelineConnector: View {
    @Environment(\.isDark) private var isDark
    
    var body: some View {
        HStack(spacing: AppTimeline.connectorSpacing) {
            Rectangle()
                .fill((isDark ? ColorPalette.darkLineColor : ColorPalette.lightLineColor))
                .accessibilityIdentifier("connectorLine")
                .frame(width: AppTimeline.connectorLineWidth, height: AppTimeline.connectorLineHeight)
                .padding(.leading, AppTimeline.connectorLeadingPadding)
            
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Timeline connector")
        .accessibilityIdentifier("timelineConnector")
    }
}

#Preview {
    TimelineConnector()
}
