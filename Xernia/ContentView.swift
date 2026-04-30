//
//  ContentView.swift
//  Xernia
//
//  Created by Jayvic San Antonio on 4/22/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .today

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.allCases) { tab in
                NavigationStack {
                    AppTabRootView(tab: tab)
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.systemImage)
                }
                .tag(tab)
            }
        }
        .tint(.blue)
    }
}

private struct AppTabRootView: View {
    let tab: AppTab

    var body: some View {
        switch tab {
        case .today:
            TodayView()
        case .ask:
            AskView()
        case .timeline:
            TimelineView()
        case .experiments:
            ExperimentsView()
        case .settings:
            SettingsView()
        }
    }
}

#Preview {
    ContentView()
}
