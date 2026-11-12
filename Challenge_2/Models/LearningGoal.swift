//
//  LearningGoal.swift
//  Challenge_2
//

import Foundation

/// The goal the user is currently working on, e.g. "Swift" for a week.
///
/// The goal runs in whole calendar days: the day "Start learning" was tapped is day 1,
/// and it ends at midnight after its last day.
/// Example: a Week goal started Monday 3 PM covers Monday–Sunday and ends at 12 AM the next Monday.
struct LearningGoal: Codable, Equatable {
    var topic: String
    var duration: GoalDuration
    /// The exact moment the goal started (used to tell which logs belong to this goal).
    var startDate: Date

    /// Midnight after the goal's last day.
    func endDate(calendar: Calendar = .current) -> Date {
        duration.endDate(from: calendar.startOfDay(for: startDate), calendar: calendar)
    }

    /// How many calendar days the goal covers: 7 for a week, 28–31 for a month, 365–366 for a year.
    func dayCount(calendar: Calendar = .current) -> Int {
        let firstDay = calendar.startOfDay(for: startDate)
        return calendar.dateComponents([.day], from: firstDay, to: endDate(calendar: calendar)).day ?? 0
    }

    /// True once midnight after the last day has passed.
    func hasEnded(at now: Date = .now, calendar: Calendar = .current) -> Bool {
        now >= endDate(calendar: calendar)
    }
}
