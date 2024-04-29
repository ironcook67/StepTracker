//
//  StepTrackerApp.swift
//  StepTracker
//
//  Created by Chon Torres on 4/26/24.
//

import SwiftUI

@main
struct StepTrackerApp: App {
    let hkManager = HealthKitManager()

    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
        }
    }
}
