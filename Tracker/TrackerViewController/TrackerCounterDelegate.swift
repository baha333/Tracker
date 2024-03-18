//
//  TrackerCounterDelegate.swift
//  Tracker
//
//  Created by Bakhadir on 15.03.2024.
//

import Foundation

protocol TrackerCounterDelegate: AnyObject {
    func increaseTrackerCounter(trackerId: UUID, date: Date)
    func decreaseTrackerCounter(trackerId: UUID, date: Date)
    func checkIfTrackerWasCompletedAtCurrentDay(trackerId: UUID, date: Date) -> Bool
    func calculateTimesTrackerWasCompleted(trackerId: UUID) -> Int
}
