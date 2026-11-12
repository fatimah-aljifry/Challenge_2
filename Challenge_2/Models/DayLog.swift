//
//  DayLog.swift
//  Challenge_2
//

import Foundation

/// One logged day. There is at most one log per calendar day.
struct DayLog: Codable, Equatable, Identifiable {
    /// The start of the day this log belongs to (used by the Calendar and week strip).
    let day: Date
    /// The exact time the user tapped the button (used for the 32-hour streak rule).
    let loggedAt: Date
    let status: DayStatus

    var id: Date { day }

    init(status: DayStatus, loggedAt: Date = .now, calendar: Calendar = .current) {
        self.day = calendar.startOfDay(for: loggedAt)
        self.loggedAt = loggedAt
        self.status = status
    }
}
