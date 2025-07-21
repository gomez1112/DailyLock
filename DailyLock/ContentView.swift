//
//  ContentView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(NavigationContext.self) private var navigation
    @Environment(HapticEngine.self) private var haptics: HapticEngine
    
    #if !os(macOS) && !os(tvOS)
    @AppStorage("sidebarCustomizations") var tabViewCustomization: TabViewCustomization
    #endif

    
    var body: some View {
        @Bindable var navigation = navigation
        TabView(selection: $navigation.selectedTab) {
            ForEach(Tabs.allCases) { tab in
                Tab(tab.title, systemImage: tab.icon, value: tab, role: tab == .search ? .search : nil) {
                    tab.destination
                }
                .customizationID(tab.customizationID)
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .tabViewStyle(.sidebarAdaptable)
        #if !os(macOS)
        .tabViewCustomization($tabViewCustomization)
        #endif
    }
}

#Preview(traits: .previewData) {
    ContentView()
}
