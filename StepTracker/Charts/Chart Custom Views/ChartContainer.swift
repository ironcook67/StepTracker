//
//  ChartContainer.swift
//  StepTracker
//
//  Created by Chon Torres on 7/4/24.
//

import SwiftUI

enum ChartType {
    case stepBar(average: Int)
    case stepWeekdayPie
    case weightLine(average: Double)
    case weightDiffBar
}

struct ChartContainer<Content: View>: View {

    let chartType: ChartType
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading) {
            if isNav {
                navigationLinkView
            } else {
                titleView
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)
            }
            content()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        }
    }

    var navigationLinkView: some View {
        NavigationLink(value: context) {
            HStack {
                titleView
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundStyle(.secondary)
        .padding(.bottom, 12)
    }

    var titleView: some View {
        VStack(alignment: .leading) {
            Label(title, systemImage: symbol)
                .font(.title3.bold())
                .foregroundStyle(context == .steps ? .pink : .indigo)

            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    var isNav: Bool {
        switch chartType {
        case .stepBar(_), .weightLine(_):
            true
        case .stepWeekdayPie, .weightDiffBar:
            false
        }
    }

    var context: HealthMetricContext {
        switch chartType {
        case .stepBar(_), .stepWeekdayPie:
            .steps
        case .weightLine(_), .weightDiffBar:
            .weight
        }
    }

    var title: String {
        switch chartType {
        case .stepBar(_):
            "Steps"
        case .stepWeekdayPie:
            "Averages"
        case .weightLine(_):
            "Weight"
        case .weightDiffBar:
            "Average"
        }
    }

    var subtitle: String {
        switch chartType {
        case .stepBar(let averageSteps):
            "Avg: \(averageSteps.formatted()) Steps"
        case .stepWeekdayPie:
            "Last 28 Days"
        case .weightLine(let averageWeight):
            "Avg: \(averageWeight.formatted(.number.precision(.fractionLength(1)))) lbs"
        case .weightDiffBar:
            "Per Weekday (Last 28 Days)"
        }
    }

    var symbol: String {
        switch chartType {
        case .stepBar(_):
            "figure.walk"
        case .stepWeekdayPie:
            "calendar"
        case .weightLine(_), .weightDiffBar:
            "figure"
        }
    }
}

#Preview {
    ChartContainer(chartType: .weightDiffBar) {
        Text("Chart Goes Here")
            .frame(minHeight: 150)
    }
}
