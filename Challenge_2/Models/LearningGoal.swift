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

    /// The start of the goal's last day, e.g. the Sunday of a Monday–Sunday week.
    func lastDay(calendar: Calendar = .current) -> Date {
        let end = endDate(calendar: calendar)
        return calendar.date(byAdding: .day, value: -1, to: end) ?? end
    }

    /// True once midnight after the last day has passed.
    func hasEnded(at now: Date = .now, calendar: Calendar = .current) -> Bool {
        now >= endDate(calendar: calendar)
    }
}
