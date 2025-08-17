//
//  TodayViewContainer.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/17/25.
//

import SwiftUI

struct TodayViewContainer: View {
    @Environment(AppDependencies.self) private var dependencies

    var body: some View {
        TodayView(
            viewModel: TodayViewModel(
                dataService: dependencies.dataService,
                haptics: dependencies.haptics,
                syncedSetting: dependencies.syncedSetting
            )
        )
    }
}
