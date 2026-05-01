//
//  PhaseOneEditors.swift
//  Xernia
//
//  Created by Codex on 4/30/26.
//

import SwiftData
import SwiftUI

struct ManualHealthEventEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var kind: ManualHealthEventKind = .symptom
    @State private var title = ""
    @State private var detail = ""
    @State private var occurredAt = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Log") {
                    Picker("Type", selection: $kind) {
                        ForEach(ManualHealthEventKind.allCases) { kind in
                            Text(kind.title).tag(kind)
                        }
                    }
                    TextField("Title", text: $title)
                    TextField("Details", text: $detail, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                    DatePicker("When", selection: $occurredAt)
                }
            }
            .navigationTitle("Manual Log")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        modelContext.insert(ManualHealthEvent(
                            kind: kind,
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            detail: detail.trimmingCharacters(in: .whitespacesAndNewlines),
                            occurredAt: occurredAt
                        ))
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

struct ProfileEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]

    @State private var displayName = ""
    @State private var preferredName = ""
    @State private var detailPreference: DetailPreference = .standard

    var body: some View {
        Form {
            Section("Name") {
                TextField("Display name", text: $displayName)
                TextField("Preferred name", text: $preferredName)
            }

            Section("Detail Preference") {
                Picker("Default answer depth", selection: $detailPreference) {
                    ForEach(DetailPreference.allCases) { preference in
                        Text(preference.title).tag(preference)
                    }
                }
            }

            Section {
                Button("Save Profile") {
                    save()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Health Profile")
        .task {
            loadProfile()
        }
    }

    private func loadProfile() {
        guard let profile = profiles.first else { return }
        displayName = profile.displayName
        preferredName = profile.preferredName ?? ""
        detailPreference = profile.detailPreference
    }

    private func save() {
        let profile = profiles.first ?? UserProfile()
        profile.displayName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        profile.preferredName = preferredName.trimmingCharacters(in: .whitespacesAndNewlines)
        profile.detailPreference = detailPreference
        profile.updatedAt = .now

        if profiles.isEmpty {
            modelContext.insert(profile)
        }
    }
}

struct GoalsEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Goal.createdAt, order: .reverse) private var goals: [Goal]

    @State private var title = ""
    @State private var detail = ""
    @State private var category: GoalCategory = .recovery

    var body: some View {
        List {
            Section("Add Goal") {
                TextField("Goal", text: $title)
                TextField("Details", text: $detail, axis: .vertical)
                Picker("Category", selection: $category) {
                    ForEach(GoalCategory.allCases) { category in
                        Text(category.title).tag(category)
                    }
                }
                Button {
                    addGoal()
                } label: {
                    Label("Add Goal", systemImage: "plus.circle")
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            Section("Current Goals") {
                if goals.isEmpty {
                    Text("No goals yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(goals) { goal in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(goal.title)
                                .font(.headline)
                            Text(goal.summaryLine)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            modelContext.delete(goals[offset])
                        }
                    }
                }
            }
        }
        .navigationTitle("Goals")
    }

    private func addGoal() {
        modelContext.insert(Goal(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            detail: detail.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category
        ))
        title = ""
        detail = ""
    }
}

struct MedicationListEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Medication.createdAt, order: .reverse) private var medications: [Medication]

    @State private var name = ""
    @State private var dosage = ""
    @State private var scheduleNotes = ""

    var body: some View {
        List {
            Section("Add Medication") {
                TextField("Name", text: $name)
                TextField("Dosage", text: $dosage)
                TextField("Schedule notes", text: $scheduleNotes, axis: .vertical)
                Button {
                    addMedication()
                } label: {
                    Label("Add Medication", systemImage: "plus.circle")
                }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            Section("Active Medications") {
                if medications.isEmpty {
                    Text("No medications yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(medications) { medication in
                        ActiveItemRow(
                            title: medication.name,
                            subtitle: [medication.dosage, medication.scheduleNotes].compactMap { $0 }.joined(separator: " - "),
                            isActive: medication.isActive
                        )
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            modelContext.delete(medications[offset])
                        }
                    }
                }
            }
        }
        .navigationTitle("Medications")
    }

    private func addMedication() {
        modelContext.insert(Medication(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            dosage: dosage.emptyNil,
            scheduleNotes: scheduleNotes.emptyNil
        ))
        name = ""
        dosage = ""
        scheduleNotes = ""
    }
}

struct SupplementListEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Supplement.createdAt, order: .reverse) private var supplements: [Supplement]

    @State private var name = ""
    @State private var dosage = ""
    @State private var scheduleNotes = ""

    var body: some View {
        List {
            Section("Add Supplement") {
                TextField("Name", text: $name)
                TextField("Dosage", text: $dosage)
                TextField("Schedule notes", text: $scheduleNotes, axis: .vertical)
                Button {
                    addSupplement()
                } label: {
                    Label("Add Supplement", systemImage: "plus.circle")
                }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            Section("Active Supplements") {
                if supplements.isEmpty {
                    Text("No supplements yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(supplements) { supplement in
                        ActiveItemRow(
                            title: supplement.name,
                            subtitle: [supplement.dosage, supplement.scheduleNotes].compactMap { $0 }.joined(separator: " - "),
                            isActive: supplement.isActive
                        )
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            modelContext.delete(supplements[offset])
                        }
                    }
                }
            }
        }
        .navigationTitle("Supplements")
    }

    private func addSupplement() {
        modelContext.insert(Supplement(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            dosage: dosage.emptyNil,
            scheduleNotes: scheduleNotes.emptyNil
        ))
        name = ""
        dosage = ""
        scheduleNotes = ""
    }
}

struct DetailPreferencePicker: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]

    @State private var selectedPreference: DetailPreference = .standard

    var body: some View {
        Picker("Default detail", selection: $selectedPreference) {
            ForEach(DetailPreference.allCases) { preference in
                Text(preference.title).tag(preference)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: selectedPreference) { _, newValue in
            save(newValue)
        }
        .task {
            selectedPreference = profiles.first?.detailPreference ?? .standard
        }
    }

    private func save(_ preference: DetailPreference) {
        let profile = profiles.first ?? UserProfile()
        profile.detailPreference = preference
        profile.updatedAt = .now

        if profiles.isEmpty {
            modelContext.insert(profile)
        }
    }
}

private struct ActiveItemRow: View {
    let title: String
    let subtitle: String
    let isActive: Bool

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if isActive {
                Text("Active")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private extension String {
    var emptyNil: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
