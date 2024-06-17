//
//  ContentView.swift
//  StepTracker
//
//  Created by Chon Torres on 4/26/24.
//

import SwiftUI
import Charts

enum HealthMetricContext: CaseIterable, Identifiable {
    case steps, weight
    var id: Self { self }

    var title: String {
        switch self {
        case .steps:
            "Steps"
        case .weight:
            "Weight"
        }
    }
}

struct DashboardView: View {
    @Environment(HealthKitManager.self) private var hkManager

    @State private var isShowingPermissionPrimingSheet = false
    @State private var selectedStat: HealthMetricContext = .steps
    @State private var isShowingAlert = false
    @State private var fetchError: STError = .noData

    var isSteps: Bool { selectedStat == .steps }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Selected Stat", selection: $selectedStat) {
                        ForEach(HealthMetricContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)

                    switch selectedStat {
                    case .steps:
                        StepBarChart(selectedStat: selectedStat, chartData: hkManager.stepData)
                        StepPieChart(chartData: ChartMath.averageWeekdayCount(for: hkManager.stepData))
                    case .weight:
                        WeightLineChart(selectedStat: selectedStat, chartData: hkManager.weightData)
                        WeightDiffBarChart(chartData: ChartMath.averageDailyWeightDiffs(for: hkManager.weightDiffData))
                    }
                }
            }
            .padding()
            .task {
// await hkManager.addSimulatorData()
                do {
                    try await hkManager.fetchStepCount()
                    try await hkManager.fetchWeights()
                    try await hkManager.fetchWeightForDifferentials()
                } catch STError.authNotDetermined {
                    isShowingPermissionPrimingSheet = true
                } catch STError.noData {
                    fetchError = .noData
                    isShowingAlert = true
                } catch {
                    fetchError = .unableToCompleteRequest
                    isShowingAlert = true 
                }
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDataListView(isShowingPermissionPriming: $isShowingPermissionPrimingSheet, metric: metric)
            }
            .sheet(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                // fetch health data
            }, content: {
                HealthKitPermissionPrimingView()
            })
            .alert(isPresented: $isShowingAlert, error: fetchError) { fetch in
                // Action (use default buttons )
            } message: { fetchError in
                Text(fetchError.failureReason)
            }
        }
        .tint(isSteps ? .pink : .indigo)
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
