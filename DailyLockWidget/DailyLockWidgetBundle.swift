//
//  DailyLockWidgetBundle.swift
//  DailyLockWidget
//
//  Created by Gerard Gomez on 8/23/25.
//

import WidgetKit
import SwiftUI

@main
struct DailyLockWidgetBundle: WidgetBundle {
    var body: some Widget {
        DailyLockWidget()
        DailyLockWidgetControl()
        DailyLockWidgetLiveActivity()
    }
}
