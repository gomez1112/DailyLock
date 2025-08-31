//
//  DailyLockEntryWidget.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/23/25.
//

import SwiftUI
import WidgetKit

struct DailyLockEntryWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)
            
            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
    }
}

#Preview {
    DailyLockEntryWidget()
}
