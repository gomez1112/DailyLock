//
//  EnvironmentValues+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/23/25.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    var isDark: Bool { colorScheme == .dark }
}

#if os(macOS)
extension EnvironmentValues {
    @Entry var deviceStatus: DeviceStatus = .macOS
}
#else
extension EnvironmentValues {
    @Entry var deviceStatus: DeviceStatus = .compact
}
#endif

