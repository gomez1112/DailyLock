//
//  GetSizeClassModifier.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/23/25.
//

import SwiftUI

#if os(iOS)
struct GetSizeClassModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) private var horizontal
    
    private var status: DeviceStatus {
        (horizontal == .regular) ? .regular : .compact
    }
    
    func body(content: Content) -> some View {
        content.environment(\.deviceStatus, status)
    }
}
#else
struct GetSizeClassModifier: ViewModifier {
    func body(content: Content) -> some View {
        content // No-op, macOS status is set via default
    }
}
#endif
