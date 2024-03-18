//
//  TrackerInfoCell.swift
//  Tracker
//
//  Created by Bakhadir on 15.03.2024.
//

import Foundation
import UIKit

struct TrackerInfoCell {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    
    let daysCount: Int
    let currentDay: Date
    let state: State
    
    init(id: UUID, name: String, color: UIColor, emoji: String, daysCount: Int, currentDay: Date, state: State) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.daysCount = daysCount
        self.currentDay = currentDay
        self.state = state
    }
}
