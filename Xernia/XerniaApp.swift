//
//  XerniaApp.swift
//  Xernia
//
//  Created by Jayvic San Antonio on 4/22/26.
//

import SwiftUI
import SwiftData

@main
struct XerniaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [
                    UserProfile.self,
                    Goal.self,
                    Medication.self,
                    Supplement.self,
                    HealthMemory.self,
                    ConsentRecord.self
                ])
        }
    }
}
