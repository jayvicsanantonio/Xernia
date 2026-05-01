//
//  RootScreens.swift
//  Xernia
//
//  Created by Codex on 4/28/26.
//

import SwiftData
import SwiftUI

struct OnboardingView: View {
    let healthKitManager: HealthKitManager
    @Binding var isComplete: Bool

    @State private var selectedStep = 0
    @State private var modelAcknowledged = false
    @State private var privacyReviewed = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TabView(selection: $selectedStep) {
                    OnboardingStepView(
                        systemImage: "heart.text.square",
                        title: "Connect your health context.",
                        detail: "Xernia starts with Apple Health, your goals, and simple manual logs. Nothing is sent to a cloud AI service for the MVP."
                    )
                    .tag(0)

                    AppleHealthOnboardingStep(healthKitManager: healthKitManager)
                        .tag(1)

                    OnboardingStepView(
                        systemImage: "cpu",
                        title: "Prepare local AI.",
                        detail: "The Gemma model will be installed later as an on-device download. You can use the app for tracking before chat is ready.",
                        footer: {
                            Toggle("Remind me to install the local model", isOn: $modelAcknowledged)
                        }
                    )
                    .tag(2)

                    OnboardingStepView(
                        systemImage: "lock.shield",
                        title: "Review privacy basics.",
                        detail: "Health permissions stay explicit. Imported data keeps its source, timestamp, and unit so you can inspect what Xernia used.",
                        footer: {
                            Toggle("I reviewed the privacy expectations", isOn: $privacyReviewed)
                        }
                    )
                    .tag(3)
                }
                .tabViewStyle(.page)

                Button(selectedStep == 3 ? "Start Using Xernia" : "Continue") {
                    if selectedStep == 3 {
                        isComplete = true
                    } else {
                        selectedStep += 1
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding()
                .accessibilityIdentifier("onboarding-primary-action")
            }
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct AppleHealthOnboardingStep: View {
    let healthKitManager: HealthKitManager

    var body: some View {
        OnboardingStepView(
            systemImage: "heart",
            title: "Choose Apple Health access.",
            detail: "Xernia asks only for read access to MVP categories like sleep, workouts, steps, energy, heart rate, HRV, and walking or running distance.",
            footer: {
                VStack(alignment: .leading, spacing: 12) {
                StatusPill(title: healthKitManager.connectionState.title)

                Button {
                    Task {
                        await healthKitManager.requestAuthorization()
                    }
                } label: {
                    Label("Connect Apple Health", systemImage: "heart.circle")
                }
                .buttonStyle(.borderedProminent)
                .disabled(healthKitManager.connectionState == .unavailable)
                .accessibilityIdentifier("connect-apple-health")
                }
            }
        )
    }
}

private struct OnboardingStepView<Footer: View>: View {
    let systemImage: String
    let title: String
    let detail: String
    @ViewBuilder let footer: Footer

    init(
        systemImage: String,
        title: String,
        detail: String,
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) {
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
        self.footer = footer()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Image(systemName: systemImage)
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(.blue)
                .frame(width: 64, height: 64)

            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.largeTitle.weight(.semibold))
                Text(detail)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            footer

            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TodayView: View {
    let healthKitManager: HealthKitManager

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \HealthMetricSample.endDate, order: .reverse) private var healthSamples: [HealthMetricSample]
    @Query(sort: \ManualHealthEvent.occurredAt, order: .reverse) private var manualEvents: [ManualHealthEvent]
    @Query(sort: \Goal.createdAt, order: .reverse) private var goals: [Goal]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeroCard(
                    eyebrow: "Phase 1",
                    title: "Build today from your own health context.",
                    detail: todaySummary
                )

                SectionCard("Apple Health") {
                    VStack(alignment: .leading, spacing: 12) {
                        StatusRow(title: "Connection", value: healthKitManager.connectionState.title)
                        StatusRow(title: "Stored samples", value: "\(healthSamples.count)")
                        if let lastSyncedAt = healthKitManager.syncSummary.lastSyncedAt {
                            StatusRow(title: "Last sync", value: lastSyncedAt.formatted(date: .abbreviated, time: .shortened))
                        }

                        HStack {
                            Button {
                                Task { await connectAndSync() }
                            } label: {
                                Label(syncButtonTitle, systemImage: "arrow.clockwise")
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(healthKitManager.isSyncing || healthKitManager.connectionState == .unavailable)

                            if healthKitManager.isSyncing {
                                ProgressView()
                            }
                        }
                    }
                }

                SectionCard("Goals") {
                    if goals.isEmpty {
                        Text("Add goals in Settings to shape daily guidance.")
                            .foregroundStyle(.secondary)
                    } else {
                        BulletList(items: goals.prefix(3).map(\.summaryLine))
                    }
                }

                SectionCard("Recent Timeline") {
                    RecentTimelineList(samples: Array(healthSamples.prefix(3)), events: Array(manualEvents.prefix(3)))
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Today")
        .navigationBarTitleDisplayMode(.large)
        .accessibilityIdentifier("screen-today")
        .task {
            healthKitManager.refreshAuthorizationStatus()
        }
    }

    private var syncButtonTitle: String {
        healthKitManager.connectionState == .sharingAuthorized ? "Sync Recent Data" : "Connect + Sync"
    }

    private var todaySummary: String {
        if healthSamples.isEmpty && manualEvents.isEmpty {
            return "Connect Apple Health or add a manual log to start turning the shell into a personal daily companion."
        }

        return "Xernia has \(healthSamples.count) Apple Health samples and \(manualEvents.count) manual logs ready for timeline and planning."
    }

    private func connectAndSync() async {
        if healthKitManager.connectionState != .sharingAuthorized {
            await healthKitManager.requestAuthorization()
        }

        let syncedSamples = await healthKitManager.syncRecentSamples()
        for sample in syncedSamples where !healthSamples.contains(where: { existing in
            existing.kind == sample.kind &&
            existing.startDate == sample.startDate &&
            existing.endDate == sample.endDate &&
            existing.value == sample.value
        }) {
            modelContext.insert(sample)
        }
    }
}

struct AskView: View {
    @Query private var healthSamples: [HealthMetricSample]
    @Query private var manualEvents: [ManualHealthEvent]
    @Query private var memories: [HealthMemory]

    private let exampleQuestions = [
        "Why was my recovery lower this week?",
        "What changed before these headaches started?",
        "How should I prepare for my next doctor visit?"
    ]

    var body: some View {
        List {
            Section("Readiness") {
                StatusRow(title: "Apple Health samples", value: "\(healthSamples.count)")
                StatusRow(title: "Manual logs", value: "\(manualEvents.count)")
                StatusRow(title: "Health memories", value: "\(memories.count)")
                StatusRow(title: "On-device Gemma", value: "Planned")
            }

            Section("Example Questions") {
                ForEach(exampleQuestions, id: \.self) { question in
                    Label(question, systemImage: "text.bubble")
                }
            }

            Section("MVP Boundary") {
                Text("Ask remains offline-first and local-model-only. Phase 1 is collecting the health context that will ground answers later.")
            }
        }
        .navigationTitle("Ask")
        .accessibilityIdentifier("screen-ask")
    }
}

struct TimelineView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \HealthMetricSample.endDate, order: .reverse) private var healthSamples: [HealthMetricSample]
    @Query(sort: \ManualHealthEvent.occurredAt, order: .reverse) private var manualEvents: [ManualHealthEvent]

    @State private var isShowingManualEntry = false

    var body: some View {
        List {
            Section {
                Button {
                    isShowingManualEntry = true
                } label: {
                    Label("Add Manual Log", systemImage: "plus.circle")
                }
                .accessibilityIdentifier("add-manual-log")
            }

            Section("Manual Logs") {
                if manualEvents.isEmpty {
                    Text("Symptoms, mood, hydration, caffeine, alcohol, medications, supplements, and notes will appear here.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(manualEvents) { event in
                        TimelineEventRow(event: event)
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            modelContext.delete(manualEvents[offset])
                        }
                    }
                }
            }

            Section("Apple Health") {
                if healthSamples.isEmpty {
                    Text("Connect and sync Apple Health from Today or Settings.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(healthSamples.prefix(50)) { sample in
                        HealthSampleRow(sample: sample)
                    }
                }
            }
        }
        .navigationTitle("Timeline")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingManualEntry = true
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isShowingManualEntry) {
            ManualHealthEventEditor()
        }
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
                    eyebrow: "Phase 1 Ready",
                    title: "Experiments now have profile and timeline inputs.",
                    detail: "After Apple Health and manual logs accumulate, this area can graduate from planning scaffold to structured N-of-1 tracking."
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
    let healthKitManager: HealthKitManager

    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedPhaseOneOnboarding") private var hasCompletedOnboarding = false
    @Query private var profiles: [UserProfile]
    @Query private var goals: [Goal]
    @Query private var medications: [Medication]
    @Query private var supplements: [Supplement]
    @Query private var healthSamples: [HealthMetricSample]

    var body: some View {
        List {
            Section("Sources") {
                LabeledContent("Apple Health", value: healthKitManager.connectionState.title)
                LabeledContent("Local AI model", value: "Not installed")
                LabeledContent("Local database", value: "Configured")
                LabeledContent("Stored health samples", value: "\(healthSamples.count)")

                Button {
                    Task { await connectAndSync() }
                } label: {
                    Label("Connect or Sync Apple Health", systemImage: "heart.circle")
                }
                .disabled(healthKitManager.isSyncing || healthKitManager.connectionState == .unavailable)
            }

            Section("Profile") {
                NavigationLink("Health Profile") {
                    ProfileEditorView()
                }
                NavigationLink("Goals") {
                    GoalsEditorView()
                }
                NavigationLink("Medications") {
                    MedicationListEditorView()
                }
                NavigationLink("Supplements") {
                    SupplementListEditorView()
                }
            }

            Section("Detail Preference") {
                DetailPreferencePicker()
            }

            Section("Privacy") {
                Text("Apple Health access is read-only. Xernia stores imported samples locally with source and timestamp metadata.")
                Button("Show Onboarding Again") {
                    hasCompletedOnboarding = false
                }
            }
        }
        .navigationTitle("Settings")
        .accessibilityIdentifier("screen-settings")
        .task {
            healthKitManager.refreshAuthorizationStatus()
        }
    }

    private func connectAndSync() async {
        if healthKitManager.connectionState != .sharingAuthorized {
            await healthKitManager.requestAuthorization()
        }

        let syncedSamples = await healthKitManager.syncRecentSamples()
        for sample in syncedSamples where !healthSamples.contains(where: { existing in
            existing.kind == sample.kind &&
            existing.startDate == sample.startDate &&
            existing.endDate == sample.endDate &&
            existing.value == sample.value
        }) {
            modelContext.insert(sample)
        }
    }
}

private struct RecentTimelineList: View {
    let samples: [HealthMetricSample]
    let events: [ManualHealthEvent]

    var body: some View {
        if samples.isEmpty && events.isEmpty {
            Text("No timeline records yet.")
                .foregroundStyle(.secondary)
        } else {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(events) { event in
                    TimelineEventRow(event: event)
                }
                ForEach(samples) { sample in
                    HealthSampleRow(sample: sample)
                }
            }
        }
    }
}

private struct HealthSampleRow: View {
    let sample: HealthMetricSample

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "waveform.path.ecg")
                .foregroundStyle(.blue)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(sample.kind.title)
                    .font(.headline)
                Text(sample.formattedValue)
                    .foregroundStyle(.secondary)
                if let notes = sample.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Text(sample.endDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct TimelineEventRow: View {
    let event: ManualHealthEvent

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "note.text")
                .foregroundStyle(.green)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                Text(event.kind.title)
                    .foregroundStyle(.secondary)
                if !event.detail.isEmpty {
                    Text(event.detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Text(event.occurredAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct StatusPill: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.blue.opacity(0.12))
            .clipShape(Capsule())
            .foregroundStyle(.blue)
    }
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
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
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
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
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
        TodayView(healthKitManager: HealthKitManager())
    }
    .modelContainer(for: [
        UserProfile.self,
        Goal.self,
        Medication.self,
        Supplement.self,
        HealthMemory.self,
        ConsentRecord.self,
        HealthMetricSample.self,
        ManualHealthEvent.self
    ], inMemory: true)
}
