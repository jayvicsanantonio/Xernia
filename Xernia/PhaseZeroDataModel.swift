//
//  PhaseZeroDataModel.swift
//  Xernia
//
//  Created by Codex on 4/28/26.
//

import Foundation
import SwiftData

enum DetailPreference: String, Codable, CaseIterable, Identifiable {
    case simple
    case standard
    case advanced

    var id: Self { self }

    var title: String {
        rawValue.capitalized
    }
}

enum GoalCategory: String, Codable, CaseIterable, Identifiable {
    case sleep
    case activity
    case recovery
    case symptoms
    case nutrition
    case habits

    var id: Self { self }

    var title: String {
        rawValue.capitalized
    }
}

enum GoalStatus: String, Codable, CaseIterable, Identifiable {
    case active
    case paused
    case completed

    var id: Self { self }
}

enum HealthMemoryCategory: String, Codable, CaseIterable, Identifiable {
    case baseline
    case medical
    case lifestyle
    case preferences

    var id: Self { self }

    var title: String {
        rawValue.capitalized
    }
}

enum ConsentKind: String, Codable, CaseIterable, Identifiable {
    case appleHealth
    case localAI
    case notifications
    case privacyPolicy

    var id: Self { self }

    var title: String {
        switch self {
        case .appleHealth:
            "Apple Health"
        case .localAI:
            "Local AI"
        case .notifications:
            "Notifications"
        case .privacyPolicy:
            "Privacy Policy"
        }
    }
}

enum ConsentStatus: String, Codable, CaseIterable, Identifiable {
    case pending
    case granted
    case declined
    case revoked

    var id: Self { self }
}

enum PhaseZeroDataModel {
    static let entityNames = [
        "UserProfile",
        "Goal",
        "Medication",
        "Supplement",
        "HealthMemory",
        "ConsentRecord",
        "HealthMetricSample",
        "ManualHealthEvent"
    ]
}

@Model
final class UserProfile {
    var displayName: String
    var preferredName: String?
    var detailPreference: DetailPreference
    var createdAt: Date
    var updatedAt: Date

    init(
        displayName: String = "",
        preferredName: String? = nil,
        detailPreference: DetailPreference = .standard,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.displayName = displayName
        self.preferredName = preferredName
        self.detailPreference = detailPreference
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var resolvedName: String {
        let preferred = preferredName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !preferred.isEmpty {
            return preferred
        }

        let display = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        return display.isEmpty ? "You" : display
    }
}

@Model
final class Goal {
    var title: String
    var detail: String
    var category: GoalCategory
    var status: GoalStatus
    var createdAt: Date
    var updatedAt: Date

    init(
        title: String,
        detail: String = "",
        category: GoalCategory,
        status: GoalStatus = .active,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.title = title
        self.detail = detail
        self.category = category
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var summaryLine: String {
        if detail.isEmpty {
            return category.title
        }

        return "\(category.title): \(detail)"
    }
}

@Model
final class Medication {
    var name: String
    var dosage: String?
    var scheduleNotes: String?
    var isActive: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        name: String,
        dosage: String? = nil,
        scheduleNotes: String? = nil,
        isActive: Bool = true,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.name = name
        self.dosage = dosage
        self.scheduleNotes = scheduleNotes
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

@Model
final class Supplement {
    var name: String
    var dosage: String?
    var scheduleNotes: String?
    var isActive: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        name: String,
        dosage: String? = nil,
        scheduleNotes: String? = nil,
        isActive: Bool = true,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.name = name
        self.dosage = dosage
        self.scheduleNotes = scheduleNotes
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

@Model
final class HealthMemory {
    var title: String
    var detail: String
    var category: HealthMemoryCategory
    var isEnabled: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        title: String,
        detail: String,
        category: HealthMemoryCategory,
        isEnabled: Bool = true,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.title = title
        self.detail = detail
        self.category = category
        self.isEnabled = isEnabled
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

@Model
final class ConsentRecord {
    var kind: ConsentKind
    var status: ConsentStatus
    var recordedAt: Date
    var notes: String?

    init(
        kind: ConsentKind,
        status: ConsentStatus = .pending,
        recordedAt: Date = .now,
        notes: String? = nil
    ) {
        self.kind = kind
        self.status = status
        self.recordedAt = recordedAt
        self.notes = notes
    }

    var isGranted: Bool {
        status == .granted
    }
}

enum HealthMetricKind: String, Codable, CaseIterable, Identifiable {
    case steps
    case activeEnergy
    case heartRate
    case restingHeartRate
    case heartRateVariability
    case walkingRunningDistance
    case sleep
    case workout
    case mindfulness

    var id: Self { self }

    var title: String {
        switch self {
        case .steps:
            "Steps"
        case .activeEnergy:
            "Active Energy"
        case .heartRate:
            "Heart Rate"
        case .restingHeartRate:
            "Resting Heart Rate"
        case .heartRateVariability:
            "HRV"
        case .walkingRunningDistance:
            "Walking + Running"
        case .sleep:
            "Sleep"
        case .workout:
            "Workout"
        case .mindfulness:
            "Mindfulness"
        }
    }
}

enum ManualHealthEventKind: String, Codable, CaseIterable, Identifiable {
    case symptom
    case medication
    case supplement
    case hydration
    case caffeine
    case alcohol
    case mood
    case note

    var id: Self { self }

    var title: String {
        rawValue.capitalized
    }
}

@Model
final class HealthMetricSample {
    var kind: HealthMetricKind
    var sourceName: String
    var value: Double
    var unit: String
    var startDate: Date
    var endDate: Date
    var importedAt: Date
    var notes: String?

    init(
        kind: HealthMetricKind,
        sourceName: String = "Apple Health",
        value: Double,
        unit: String,
        startDate: Date,
        endDate: Date,
        importedAt: Date = .now,
        notes: String? = nil
    ) {
        self.kind = kind
        self.sourceName = sourceName
        self.value = value
        self.unit = unit
        self.startDate = startDate
        self.endDate = endDate
        self.importedAt = importedAt
        self.notes = notes
    }

    var formattedValue: String {
        if value.rounded() == value {
            "\(Int(value)) \(unit)"
        } else {
            "\(value.formatted(.number.precision(.fractionLength(1)))) \(unit)"
        }
    }
}

@Model
final class ManualHealthEvent {
    var kind: ManualHealthEventKind
    var title: String
    var detail: String
    var occurredAt: Date
    var createdAt: Date
    var updatedAt: Date

    init(
        kind: ManualHealthEventKind,
        title: String,
        detail: String = "",
        occurredAt: Date = .now,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.kind = kind
        self.title = title
        self.detail = detail
        self.occurredAt = occurredAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
