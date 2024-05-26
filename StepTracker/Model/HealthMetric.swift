//
//  HealthMetric.swift
//  StepTracker
//
//  Created by Chon Torres on 4/28/24.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
