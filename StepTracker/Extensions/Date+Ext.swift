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
}
