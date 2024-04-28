//
//  HealthKitManager.swift
//  StepTracker
//
//  Created by Chon Torres on 4/28/24.
//

import Foundation
import HealthKit
import Observation

@Observable class HealthKitManager {
    let store = HKHealthStore()

    let types: Set = [
        HKQuantityType(.stepCount),
        HKQuantityType(.bodyMass)
    ]
}
