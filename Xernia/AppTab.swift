//
//  AppTab.swift
//  Xernia
//
//  Created by Codex on 4/28/26.
//

import Foundation

enum AppTab: String, CaseIterable, Identifiable {
    case today
    case ask
    case timeline
    case experiments
    case settings

    var id: Self { self }

    var title: String {
        switch self {
        case .today:
            "Today"
        case .ask:
            "Ask"
        case .timeline:
            "Timeline"
        case .experiments:
            "Experiments"
        case .settings:
            "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .today:
            "sun.max"
        case .ask:
            "bubble.left.and.text.bubble.right"
        case .timeline:
            "timeline.selection"
        case .experiments:
            "testtube.2"
        case .settings:
            "gearshape"
        }
    }
}
