//
//  AppData.swift
//  Challenge_2
//

import Foundation

/// Everything the app saves, kept together so it is always saved as one value.
struct AppData: Codable, Equatable {
    /// The current goal. `nil` means the user hasn't finished onboarding yet.
    var goal: LearningGoal?
    /// When the user finished onboarding. Set once and never changed; the Calendar starts at this month.
    var registrationDate: Date?
    /// Every logged day, across all goals.
    var logs: [DayLog] = []
    /// When the current streak began. Reset when the streak breaks or the goal is updated.
    var streakStartDate: Date?
}
