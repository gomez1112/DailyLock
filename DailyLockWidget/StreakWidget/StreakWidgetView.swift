//
//  StreakWidgetView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/24/25.
//

import AppIntents
import SwiftData
import SwiftUI
import WidgetKit

struct StreakWidgetView: View {
    @Environment(\.widgetFamily) var family
    @Query private var entries: [MomentumEntry]
    
    var body: some View {
        Group {
            switch family {
                case .systemSmall:
                    VStack {
                        Image(systemName: "flame.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)
                        Text("\(StreakCalculator.calculateStreak(from: entries).count)")
                            .font(.title)
                            .bold()
                        Text("Days")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                case .systemMedium:
                    HStack {
                        VStack {
                            Text("Current")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(StreakCalculator.calculateStreak(from: entries).count)")
                                .font(.largeTitle)
                                .bold()
                        }
                        Spacer()
                        VStack {
                            Text("Best")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(StreakCalculator.calculateLongestStreak(for: entries))")
                                .font(.largeTitle)
                                .bold()
                        }
                    }
                    .padding()
                default:
                    EmptyView()
            }
        }
    }
}
