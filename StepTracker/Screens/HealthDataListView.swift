//
//  HealthDataListView.swift
//  StepTracker
//
//  Created by Chon Torres on 4/28/24.
//

import SwiftUI

struct HealthDataListView: View {
    @Environment(HealthKitManager.self) private var hkManager

    @State private var isShowingAddData = false
    @State private var isShowingAlert = false
    @State private var writeError: STError = .noData

    @State private var addDataDate: Date = .now
    @State private var valueToAdd: String = ""

    @Binding var isShowingPermissionPriming: Bool

    var metric: HealthMetricContext

    var listData: [HealthMetric] {
          metric == .steps ? hkManager.stepData : hkManager.weightData
    }

    var body: some View {
        List(listData.reversed()) { data in
            LabeledContent {
                Text(data.value, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
            } label: {
                Text(data.date, format: .dateTime.month().day().year())
                    .accessibilityLabel(data.date.accessibilityDate)
            }
            .accessibilityElement(children: .combine)
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingAddData) {
            addDataView
        }
        .toolbar {
            Button("Add Data", systemImage: "plus") {
                isShowingAddData = true
            }
        }
    }

    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Data", selection: $addDataDate, displayedComponents: .date)
                LabeledContent(metric.title) {
                    TextField("Value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.title)
            .alert(isPresented: $isShowingAlert, error: writeError) { writeError in
                switch writeError {
                case .authNotDetermined, .invalidValue, .noData, .unableToCompleteRequest:
                    EmptyView()
                case .sharingDenied(_):
                    Button("Settings") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }

                    Button("Cancel", role: .cancel) { }
                }
            } message: { writeError in
                Text(writeError.failureReason)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        addDataToHealtKit()
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isShowingAddData = false
                    }
                }
            }
        }
    }

    private func addDataToHealtKit() {
        guard let valueToAdd = Double(valueToAdd) else {
            writeError = .invalidValue
            isShowingAlert = true
            return
        }
        Task {
            do {
                if metric == .steps{
                    try await hkManager.addStepData(for: addDataDate, value: Double(valueToAdd))
                    hkManager.stepData = try await hkManager.fetchStepCount()
                } else {
                    try await hkManager.addweightData(for: addDataDate, value: Double(valueToAdd))

                    async let weightsForLineChart = hkManager.fetchWeights(daysBack: 28)
                    async let weightsForDiffChart = hkManager.fetchWeights(daysBack: 29)

                    hkManager.weightData = try await weightsForLineChart
                    hkManager.weightDiffData =  try await weightsForDiffChart
                }

                isShowingAddData = false
            } catch STError.sharingDenied(let quantityType) {
                writeError = .sharingDenied(quantityType: quantityType)
                isShowingAlert = true
            } catch {
                writeError = .unableToCompleteRequest
                isShowingAlert = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataListView(isShowingPermissionPriming: .constant(false), metric: .weight)
            .environment(HealthKitManager())
    }
}
