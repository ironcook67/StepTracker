//
//  ChartDataTypes.swift
//  StepTracker
//
//  Created by Chon Torres on 5/1/24.
//

import Foundation

struct DateValueChartData: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let value: Double
}
