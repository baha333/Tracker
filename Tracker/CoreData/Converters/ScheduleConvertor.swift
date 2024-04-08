//
//  ScheduleConvertor.swift
//  Tracker
//
//  Created by Bakhadir on 08.04.2024.
//

import Foundation

enum Bit: Int16 {
    case zero, one
    
    var description: Int {
        switch self {
        case .one:
            return 1
        case .zero:
            return 0
        }
    }
}

final class ScheduleConvertor {
    func getSchedule(from byte: Int16) -> Set<WeekDays> {
        let arrayOfBits = convertFromUInt16(from: byte)
        var weekdays: Set<WeekDays> = []
        for (index, bit) in arrayOfBits.enumerated() {
            if bit == 1 {
                let day: WeekDays = WeekDays(rawValue: index) ?? .monday
                weekdays.insert(day)
            }
        }
        return weekdays
    }
    
    func convertScheduleToUInt16(from weekdays: Set<WeekDays>) -> Int16 {
        var byte: Int16 = 0
        for day in weekdays {
            let dayByte: Int16 = 1 << day.rawValue
            byte = byte | dayByte
        }
        return byte
    }
    
    private func bits(fromByte byte: Int16) -> [Bit] {
        var byte = byte
        var bits = [Bit](repeating: .zero, count: 16)
        for i in 0..<16 {
            let currentBit = byte & 0x01
            if currentBit != 0 {
                bits[i] = .one
            }
            byte >>= 1
        }
        return bits
    }
    
    private func convertFromUInt16(from value: Int16) -> [Int] {
        let bitsInByte = bits(fromByte: value)
        var array: [Int] = []
        for bit in bitsInByte {
            array.append(bit.description)
        }
        return array
    }
}
