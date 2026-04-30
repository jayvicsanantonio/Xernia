//
//  RootScreens.swift
//  Xernia
//
//  Created by Codex on 4/28/26.
//

import SwiftUI

struct TodayView: View {
    private let foundationItems = [
        "Product direction is documented and aligned around the iPhone-first MVP.",
        "The app now has a persistent SwiftData foundation for profile, goals, medications, supplements, memories, and consent.",
        "The primary navigation shell is in place so each roadmap feature has a real home."
    ]

    private let nextMilestones = [
        "HealthKit permission flow",
        "Apple Health sync for approved read categories",
        "Manual health event entry"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeroCard(
                    eyebrow: "Phase 0 Complete",
                    title: "Xernia now has a real iOS foundation.",
                    detail: "The app shell, initial local data model, and product scaffolding are in place. HealthKit and onboarding can build on top of this cleanly."
                )

                SectionCard("Foundation Status") {
                    BulletList(items: foundationItems)
                }

                SectionCard("Next Product Slice") {
                    BulletList(items: nextMilestones)
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Today")
        .navigationBarTitleDisplayMode(.large)
        .accessibilityIdentifier("screen-today")
    }
}

struct AskView: View {
    private let exampleQuestions = [
        "Why was my recovery lower this week?",
        "What changed before these headaches started?",
        "How should I prepare for my next doctor visit?"
    ]

    var body: some View {
        List {
            Section("Purpose") {
                Text("Ask will become the plain-language health assistant grounded in Apple Health, manual logs, and health memories.")
            }

            Section("Example Questions") {
                ForEach(exampleQuestions, id: \.self) { question in
                    Label(question, systemImage: "text.bubble")
                }
            }

            Section("Phase 0 Readiness") {
                StatusRow(title: "Assistant home", value: "Ready")
                StatusRow(title: "On-device model runtime", value: "Planned")
                StatusRow(title: "Data used inspector", value: "Planned")
            }
        }
        .navigationTitle("Ask")
        .accessibilityIdentifier("screen-ask")
    }
}

struct TimelineView: View {
    private let timelineItems = [
        TimelineSample(time: "7:00 AM", title: "Morning summary", detail: "Daily briefing will land here once HealthKit sync is connected."),
        TimelineSample(time: "12:30 PM", title: "Manual logs", detail: "Symptoms, hydration, caffeine, and notes will share this chronological stream."),
        TimelineSample(time: "8:15 PM", title: "Context builder", detail: "This timeline will become the grounding layer for Ask and Experiments.")
    ]

    var body: some View {
        List(timelineItems) { item in
            VStack(alignment: .leading, spacing: 6) {
                Text(item.time)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(item.title)
                    .font(.headline)
                Text(item.detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Timeline")
        .accessibilityIdentifier("screen-timeline")
    }
}

struct ExperimentsView: View {
    private let experimentChecklist = [
        "Define a hypothesis and intervention",
        "Choose a primary metric and baseline",
        "Track confounders and notes",
        "Summarize results with clear uncertainty"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeroCard(
                    eyebrow: "Coming Next",
                    title: "Experiments will turn insight into action.",
                    detail: "Phase 0 gives this feature a dedicated home so it can evolve from simple check-ins to structured N-of-1 workflows."
                )

                SectionCard("Experiment Scaffold") {
                    BulletList(items: experimentChecklist)
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Experiments")
        .accessibilityIdentifier("screen-experiments")
    }
}

struct SettingsView: View {
    var body: some View {
        List {
            Section("Sources") {
                StatusRow(title: "Apple Health", value: "Not connected")
                StatusRow(title: "Local AI model", value: "Not installed")
                StatusRow(title: "Local database", value: "Configured")
            }

            Section("Detail Preference") {
                ForEach(DetailPreference.allCases) { preference in
                    HStack {
                        Text(preference.title)
                        Spacer()
                        if preference == .standard {
                            Text("Default")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Section("Phase 0 Scope") {
                Text("This foundation release establishes the core shell and local data model before HealthKit, onboarding, and on-device AI arrive in later phases.")
            }
        }
        .navigationTitle("Settings")
        .accessibilityIdentifier("screen-settings")
    }
}

private struct TimelineSample: Identifiable {
    let id = UUID()
    let time: String
    let title: String
    let detail: String
}

private struct HeroCard: View {
    let eyebrow: String
    let title: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(eyebrow.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)

            Text(detail)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(.separator).opacity(0.25), lineWidth: 1)
        }
    }
}

private struct SectionCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(.separator).opacity(0.25), lineWidth: 1)
        }
    }
}

private struct BulletList: View {
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .foregroundStyle(.blue)
                        .padding(.top, 6)
                    Text(item)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

private struct StatusRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview("Today") {
    NavigationStack {
        TodayView()
    }
}
