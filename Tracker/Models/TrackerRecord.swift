//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Bakhadir on 15.03.2024.
//

import Foundation

public struct TrackerRecord {
    let id: UUID
    let date: Date
    
    init(id: UUID, date: Date) {
        self.id = id
        self.date = date
    }
}
