//
//  Date+Ext.swift
//  StepTracker
//
//  Created by Chon Torres on 5/1/24.
//

import Foundation

extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }

    var weekdayTitle: String {
        self.formatted(.dateTime.weekday(.wide))
    }

    var accessibilityDate: String {
        self.formatted(.dateTime.month(.wide).day())
    }
}
