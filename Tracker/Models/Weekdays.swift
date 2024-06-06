
import Foundation

enum Weekdays: String, CaseIterable, Codable {
    case Monday = "Monday"
    case Tuesday = "Tuesday"
    case Wednesday = "Wednesday"
    case Thursday = "Thursday"
    case Friday = "Friday"
    case Saturday = "Saturday"
    case Sunday = "Sunday"
    
    var numberValue: Int {
        switch self {
        case .Monday:
            return 2
        case .Tuesday:
            return 3
        case .Wednesday:
            return 4
        case .Thursday:
            return 5
        case .Friday:
            return 6
        case .Saturday:
            return 7
        case .Sunday:
            return 1
        }
    }
    
    var shortDayName: String {
        switch self {
        case .Monday:
            return "Mon"
        case .Tuesday:
            return "Tue"
        case .Wednesday:
            return "Wed"
        case .Thursday:
            return "Thu"
        case . Friday:
            return "Fri"
        case .Saturday:
            return "Sat"
        case .Sunday:
            return "Sun"
        }
    }
    
    var numberValueRus: Int {
        switch self {
        case .Monday:
            return 1
        case .Tuesday:
            return 2
        case .Wednesday:
            return 3
        case .Thursday:
            return 4
        case .Friday:
            return 5
        case .Saturday:
            return 6
        case .Sunday:
            return 7
        }
    }
    
    static func fromNumberValue(_ number: Int) -> String {
        return Weekdays.allCases.first { $0.numberValue == number }!.rawValue
    }
}


  
