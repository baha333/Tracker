//
//  Date+Extension.swift
//  Tracker
//
//  Created by Bakhadir on 08.05.2024.
//

import Foundation

extension Date {
    var onlyDate: Date? {
        get {
            let calender = Calendar.current
            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = NSTimeZone.system

            return calender.date(from: dateComponents)
        }
    }
    
}
