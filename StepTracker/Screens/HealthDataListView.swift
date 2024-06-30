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
            HStack {
                Text(data.date, format: .dateTime.month().day().year())
                Spacer()
                Text(data.value, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
            }
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
                HStack {
                    Text(metric.title)
                    Spacer()
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
                        guard let valueToAdd = Double(valueToAdd) else {
                            writeError = .invalidValue
                            isShowingAlert = true
                            return
                        }
                        Task {
                            if metric == .steps {
                                do {
                                    // TODO: Input Validation. Use the onEditingChange in the TextField to turn the text
                                    // red if there is an invlid number entered. 
                                    try await hkManager.addStepData(for: addDataDate, value: Double(valueToAdd))
                                    try await hkManager.fetchStepCount()
                                    isShowingAddData = false
                                } catch STError.authNotDetermined {
                                    isShowingPermissionPriming = true
                                } catch STError.sharingDenied(let quantityType) {
                                    writeError = .sharingDenied(quantityType: quantityType)
                                    isShowingAlert = true
                                } catch {
                                    writeError = .unableToCompleteRequest
                                    isShowingAlert = true
                                }
                            } else {
                                do {
                                    try await hkManager.addweightData(for: addDataDate, value: Double(valueToAdd))
                                    try await hkManager.fetchWeights()
                                    try await hkManager.fetchWeightForDifferentials()
                                    isShowingAddData = false
                                } catch STError.authNotDetermined {
                                    isShowingPermissionPriming = true
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
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isShowingAddData = false
                    }
                }
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
