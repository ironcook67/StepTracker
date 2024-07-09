//
//  ChartHelpers.swift
//  StepTracker
//
//  Created by Chon Torres on 7/4/24.
//

import Foundation

struct ChartHelper {
    static func convertData(data: [HealthMetric]) -> [DateValueChartData] {
        data.map {.init(date: $0.date, value: $0.value) }
    }

    static func parseSelectedData(from data: [DateValueChartData], in selectedDate: Date?) -> DateValueChartData? {
        guard let selectedDate else { return nil }
        return data.first {
            Calendar.current.isDate(selectedDate, inSameDayAs: $0.date)
        }
    }
}
