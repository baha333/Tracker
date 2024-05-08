//
//  Tracker.swift
//  Tracker
//
//  Created by Bakhadir on 15.03.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]
    let isPinned: Bool
}
