//
//  TrackerCreationDelegate.swift
//  Tracker
//
//  Created by Bakhadir on 18.03.2024.
//

import Foundation

protocol TrackerCreationDelegate: AnyObject {
    func createTracker(tracker: Tracker, category: String)
}
