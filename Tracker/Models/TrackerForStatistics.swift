import Foundation

struct TrackerForStatistics {
    let id: UUID
    let schedule: [Weekdays?]
    var dateEvent: Date?
    let completedAt: [Date]
}
