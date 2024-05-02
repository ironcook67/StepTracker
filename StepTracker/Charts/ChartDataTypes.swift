//
//  ChartDataTypes.swift
//  StepTracker
//
//  Created by Chon Torres on 5/1/24.
//

import Foundation

struct WeekdayChartData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
