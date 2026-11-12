//
//  DayLog.swift
//  Challenge_2
//

import Foundation

/// One logged day. There is at most one log per calendar day *per goal*, so a day can have
/// two logs if the goal was updated in between (the Calendar shows learned over frozen).
struct DayLog: Codable, Equatable, Identifiable {
    /// The start of the day this log belongs to (used by the Calendar and week strip).
    let day: Date
    /// The exact time the user tapped the button (used for the 32-hour streak rule
    /// and to tell which goal the log belongs to).
    let loggedAt: Date
    let status: DayStatus

    var id: Date { loggedAt }

    init(status: DayStatus, loggedAt: Date = .now, calendar: Calendar = .current) {
        self.day = calendar.startOfDay(for: loggedAt)
        self.loggedAt = loggedAt
        self.status = status
    }
}
