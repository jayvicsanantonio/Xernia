//
//  ContentView.swift
//  Xernia
//
//  Created by Jayvic San Antonio on 4/22/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedPhaseOneOnboarding") private var hasCompletedOnboarding = false
    @State private var selectedTab: AppTab = .today
    @State private var healthKitManager = HealthKitManager()

    init() {
        if ProcessInfo.processInfo.arguments.contains("-skipOnboarding") {
            UserDefaults.standard.set(true, forKey: "hasCompletedPhaseOneOnboarding")
        }
    }

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                TabView(selection: $selectedTab) {
                    ForEach(AppTab.allCases) { tab in
                        NavigationStack {
                            AppTabRootView(tab: tab, healthKitManager: healthKitManager)
                        }
                        .tabItem {
                            Label(tab.title, systemImage: tab.systemImage)
                        }
                        .tag(tab)
                    }
                }
                .tint(.blue)
            } else {
                OnboardingView(
                    healthKitManager: healthKitManager,
                    isComplete: $hasCompletedOnboarding
                )
            }
        }
    }
}

private struct AppTabRootView: View {
    let tab: AppTab
    let healthKitManager: HealthKitManager

    var body: some View {
        switch tab {
        case .today:
            TodayView(healthKitManager: healthKitManager)
        case .ask:
            AskView()
        case .timeline:
            TimelineView()
        case .experiments:
            ExperimentsView()
        case .settings:
            SettingsView(healthKitManager: healthKitManager)
        }
    }
}

#Preview {
    ContentView()
}
