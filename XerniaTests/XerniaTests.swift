//
//  XerniaTests.swift
//  XerniaTests
//
//  Created by Jayvic San Antonio on 4/22/26.
//

import Foundation
import Testing
@testable import Xernia

struct XerniaTests {

    @Test func phaseZeroAppShellMatchesRoadmap() async throws {
        #expect(AppTab.allCases.map(\.title) == [
            "Today",
            "Ask",
            "Timeline",
            "Experiments",
            "Settings"
        ])
    }

    @Test func phaseZeroDataModelIncludesFoundationEntities() async throws {
        #expect(PhaseZeroDataModel.entityNames == [
            "UserProfile",
            "Goal",
            "Medication",
            "Supplement",
            "HealthMemory",
            "ConsentRecord",
            "HealthMetricSample",
            "ManualHealthEvent"
        ])
    }

    @Test func userProfileFallsBackToGenericNameWhenBlank() async throws {
        let profile = UserProfile(displayName: "  ", preferredName: nil)

        #expect(profile.resolvedName == "You")
    }

    @Test func consentRecordReflectsGrantedStatus() async throws {
        let consent = ConsentRecord(kind: .appleHealth, status: .granted)

        #expect(consent.isGranted)
    }

    @Test func healthMetricSampleFormatsWholeNumbers() async throws {
        let sample = HealthMetricSample(
            kind: .steps,
            value: 1200,
            unit: "steps",
            startDate: .now,
            endDate: .now
        )

        #expect(sample.formattedValue == "1200 steps")
    }

}
