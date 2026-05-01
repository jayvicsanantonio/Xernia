//
//  HealthKitManager.swift
//  Xernia
//
//  Created by Codex on 4/30/26.
//

import Foundation
import Observation

#if os(iOS)
import HealthKit
#endif

enum HealthKitConnectionState: Equatable {
    case unavailable
    case notRequested
    case sharingAuthorized
    case sharingDenied
    case error(String)

    var title: String {
        switch self {
        case .unavailable:
            "Unavailable"
        case .notRequested:
            "Not connected"
        case .sharingAuthorized:
            "Connected"
        case .sharingDenied:
            "Permission needed"
        case .error:
            "Needs review"
        }
    }
}

struct HealthKitSyncSummary: Equatable {
    var sampleCount: Int
    var lastSyncedAt: Date?

    static let empty = HealthKitSyncSummary(sampleCount: 0, lastSyncedAt: nil)
}

@Observable
final class HealthKitManager {
    private(set) var connectionState: HealthKitConnectionState = .notRequested
    private(set) var syncSummary: HealthKitSyncSummary = .empty
    private(set) var isSyncing = false

#if os(iOS)
    private let healthStore = HKHealthStore()
#endif

    init() {
        refreshAuthorizationStatus()
    }

    func refreshAuthorizationStatus() {
#if os(iOS)
        guard HKHealthStore.isHealthDataAvailable() else {
            connectionState = .unavailable
            return
        }

        let statuses = Self.readObjectTypes.map { healthStore.authorizationStatus(for: $0) }
        if statuses.contains(.sharingDenied) {
            connectionState = .sharingDenied
        } else if statuses.contains(.sharingAuthorized) {
            connectionState = .sharingAuthorized
        } else {
            connectionState = .notRequested
        }
#else
        connectionState = .unavailable
#endif
    }

    func requestAuthorization() async {
#if os(iOS)
        guard HKHealthStore.isHealthDataAvailable() else {
            connectionState = .unavailable
            return
        }

        do {
            try await healthStore.requestAuthorization(toShare: [], read: Set(Self.readObjectTypes))
            refreshAuthorizationStatus()
        } catch {
            connectionState = .error(error.localizedDescription)
        }
#else
        connectionState = .unavailable
#endif
    }

    func syncRecentSamples() async -> [HealthMetricSample] {
#if os(iOS)
        guard case .sharingAuthorized = connectionState else {
            return []
        }

        isSyncing = true
        defer { isSyncing = false }

        var samples: [HealthMetricSample] = []
        do {
            samples.append(contentsOf: try await quantitySamples(
                identifier: .stepCount,
                kind: .steps,
                unit: .count(),
                displayUnit: "steps"
            ))
            samples.append(contentsOf: try await quantitySamples(
                identifier: .activeEnergyBurned,
                kind: .activeEnergy,
                unit: .kilocalorie(),
                displayUnit: "kcal"
            ))
            samples.append(contentsOf: try await quantitySamples(
                identifier: .heartRate,
                kind: .heartRate,
                unit: HKUnit.count().unitDivided(by: .minute()),
                displayUnit: "bpm"
            ))
            samples.append(contentsOf: try await quantitySamples(
                identifier: .restingHeartRate,
                kind: .restingHeartRate,
                unit: HKUnit.count().unitDivided(by: .minute()),
                displayUnit: "bpm"
            ))
            samples.append(contentsOf: try await quantitySamples(
                identifier: .heartRateVariabilitySDNN,
                kind: .heartRateVariability,
                unit: .secondUnit(with: .milli),
                displayUnit: "ms"
            ))
            samples.append(contentsOf: try await quantitySamples(
                identifier: .distanceWalkingRunning,
                kind: .walkingRunningDistance,
                unit: .mile(),
                displayUnit: "mi"
            ))
            samples.append(contentsOf: try await categoryDurationSamples(
                identifier: .sleepAnalysis,
                kind: .sleep,
                unit: "hr"
            ))
            samples.append(contentsOf: try await categoryDurationSamples(
                identifier: .mindfulSession,
                kind: .mindfulness,
                unit: "min"
            ))
            samples.append(contentsOf: try await workoutSamples())

            syncSummary = HealthKitSyncSummary(sampleCount: samples.count, lastSyncedAt: .now)
            return samples
        } catch {
            connectionState = .error(error.localizedDescription)
            return samples
        }
#else
        connectionState = .unavailable
        return []
#endif
    }

#if os(iOS)
    private static var readObjectTypes: [HKObjectType] {
        var types: [HKObjectType] = [
            HKObjectType.quantityType(forIdentifier: .stepCount),
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
            HKObjectType.quantityType(forIdentifier: .heartRate),
            HKObjectType.quantityType(forIdentifier: .restingHeartRate),
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN),
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis),
            HKObjectType.workoutType()
        ].compactMap { $0 }

        if let mindfulSession = HKObjectType.categoryType(forIdentifier: .mindfulSession) {
            types.append(mindfulSession)
        }

        return types
    }

    private func quantitySamples(
        identifier: HKQuantityTypeIdentifier,
        kind: HealthMetricKind,
        unit: HKUnit,
        displayUnit: String
    ) async throws -> [HealthMetricSample] {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else {
            return []
        }

        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -14, to: .now) ?? .now
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: .now)
        let descriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: 25,
                sortDescriptors: [descriptor]
            ) { _, rawSamples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let mappedSamples = (rawSamples as? [HKQuantitySample] ?? []).map { sample in
                    HealthMetricSample(
                        kind: kind,
                        sourceName: sample.sourceRevision.source.name,
                        value: sample.quantity.doubleValue(for: unit),
                        unit: displayUnit,
                        startDate: sample.startDate,
                        endDate: sample.endDate
                    )
                }
                continuation.resume(returning: mappedSamples)
            }

            healthStore.execute(query)
        }
    }

    private func categoryDurationSamples(
        identifier: HKCategoryTypeIdentifier,
        kind: HealthMetricKind,
        unit: String
    ) async throws -> [HealthMetricSample] {
        guard let categoryType = HKObjectType.categoryType(forIdentifier: identifier) else {
            return []
        }

        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -14, to: .now) ?? .now
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: .now)
        let descriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: categoryType,
                predicate: predicate,
                limit: 25,
                sortDescriptors: [descriptor]
            ) { _, rawSamples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let mappedSamples = (rawSamples as? [HKCategorySample] ?? []).map { sample in
                    let seconds = sample.endDate.timeIntervalSince(sample.startDate)
                    let value = unit == "hr" ? seconds / 3600 : seconds / 60

                    return HealthMetricSample(
                        kind: kind,
                        sourceName: sample.sourceRevision.source.name,
                        value: value,
                        unit: unit,
                        startDate: sample.startDate,
                        endDate: sample.endDate
                    )
                }
                continuation.resume(returning: mappedSamples)
            }

            healthStore.execute(query)
        }
    }

    private func workoutSamples() async throws -> [HealthMetricSample] {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -14, to: .now) ?? .now
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: .now)
        let descriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: HKObjectType.workoutType(),
                predicate: predicate,
                limit: 25,
                sortDescriptors: [descriptor]
            ) { _, rawSamples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let mappedSamples = (rawSamples as? [HKWorkout] ?? []).map { workout in
                    HealthMetricSample(
                        kind: .workout,
                        sourceName: workout.sourceRevision.source.name,
                        value: workout.duration / 60,
                        unit: "min",
                        startDate: workout.startDate,
                        endDate: workout.endDate,
                        notes: workout.workoutActivityType.displayName
                    )
                }
                continuation.resume(returning: mappedSamples)
            }

            healthStore.execute(query)
        }
    }
#endif
}

#if os(iOS)
private extension HKWorkoutActivityType {
    var displayName: String {
        switch self {
        case .cycling:
            "Cycling"
        case .functionalStrengthTraining:
            "Strength Training"
        case .mindAndBody:
            "Mind and Body"
        case .running:
            "Running"
        case .traditionalStrengthTraining:
            "Strength Training"
        case .walking:
            "Walking"
        case .yoga:
            "Yoga"
        default:
            "Workout"
        }
    }
}
#endif
