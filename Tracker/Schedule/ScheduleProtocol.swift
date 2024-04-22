//
//  ScheduleProtocol.swift
//  Tracker
//
//  Created by Bakhadir on 17.03.2024.
//

import Foundation

protocol ScheduleProtocol: AnyObject {
    func saveSelectedDays(selectedDays: Set<WeekDays>)
}
