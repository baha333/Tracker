//
//  Tracker.swift
//  Tracker
//
//  Created by Bakhadir on 15.03.2024.
//

import Foundation
import UIKit

public struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<WeekDays>
    let state: State
    
    init(name: String, color: UIColor, emoji: String, schedule: Set<WeekDays>, state: State) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.state = state
    }
    
    init(id: UUID, name: String, color: UIColor, emoji: String, schedule: Set<WeekDays>, state: State) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.state = state
    }
}
