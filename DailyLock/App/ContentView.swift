//
//  ContentView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import AppIntents
import SwiftData
import SwiftUI

struct ContentView: View {

    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.modelContext) private var modelContext
    
#if !os(macOS) && !os(tvOS)
    @AppStorage("sidebarCustomizations") var tabViewCustomization: TabViewCustomization
#endif
    
    
    var body: some View {
        Group {
            if dependencies.syncedSetting.hasCompletedOnboarding {
                contentView
                    .accessibilityIdentifier("mainTabView")
                    .onAppIntentExecution(OpenEntryIntent.self) { _ in
                        dependencies.navigation.navigate(to: .today)
                    }
                
            } else {
                OnboardingView()
                    .accessibilityIdentifier("onboardingView")
                    
            }
        }
        .sheet(item: Bindable(dependencies.navigation).presentedSheet) { sheet in
            switch sheet {
                case .paywall: PaywallView()
                case .tips: TipsView()
                case .entryDetail(entry: let entry):
                    EntryDetailView(entry: entry)
                        .applyIf(Self.isMacOS) { $0.frame(minWidth: AppLayout.timelineMonthSheetMinWidth, minHeight: AppLayout.timelineMonthSheetMinHeight) }
                        .applyIf(Self.isIOS) { $0.presentationDetents([.medium, .large]) }
                case .textureStoreView: TextureStoreView()
            }
        }
    }
    private var contentView: some View {
        TabView(selection: Bindable(dependencies.navigation).selectedTab) {
            ForEach(Tabs.allCases) { tab in
                Tab(tab.title, systemImage: tab.icon, value: tab, role: tab == .search ? .search : nil) {
                    tab.destination
                }
                .customizationID(tab.customizationID)
                .accessibilityIdentifier("\(tab.title)Tab")
                .accessibilityLabel(tab.title)
            }
        }
#if !os(macOS)
        .tabBarMinimizeBehavior(.onScrollDown)
#endif
        .tabViewStyle(.sidebarAdaptable)
        .accessibilityIdentifier("mainTabView")
        .accessibilityAddTraits(.isTabBar)
#if !os(macOS)
        .tabViewCustomization($tabViewCustomization)
#endif
    }
}


#Preview(traits: .previewData) {
    ContentView()
}
