//
//  FilterStructure.swift
//  Tracker
//
//  Created by Bakhadir on 08.05.2024.
//

import Foundation

enum Filter: String, CaseIterable {
    case all = "Все трекеры"
    case today = "Трекеры на сегодня"
    case completed = "Завершенные"
    case uncompleted = "Незавершенные"
}
