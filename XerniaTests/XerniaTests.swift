//
//  XerniaTests.swift
//  XerniaTests
//
//  Created by Jayvic San Antonio on 4/22/26.
//

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
            "ConsentRecord"
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

}
