//
//  STError.swift
//  StepTracker
//
//  Created by Chon Torres on 7/8/24.
//

import Foundation

enum STError: LocalizedError {
    case authNotDetermined
    case sharingDenied(quantityType: String)
    case noData
    case unableToCompleteRequest
    case invalidValue

    var errorDescription: String? {
        switch self {
        case .authNotDetermined:
            "Need access to Health data"
        case .sharingDenied(_):
            "No Write Access"
        case .noData:
            "No Data"
        case .unableToCompleteRequest:
            "Unable to Complete"
        case .invalidValue:
            "Invalid Value"
        }
    }

    var failureReason: String {
        switch self {
        case .authNotDetermined:
            "You have not given access to you Health data. Please go to Settings > Health > Data Access & Devices."
        case .sharingDenied(quantityType: let quantityType):
            "You have denied access to upload your \(quantityType) data.\n\nYou can change this in Settings > Health > Data Access & Devices."
        case .noData:
            "There is no data for this Health statistic."
        case .unableToCompleteRequest:
            "We are unable to complete your request at this time.\n\nPlease try again later or contact support."
        case .invalidValue:
            "Must be a numeric value"
        }
    }
}
