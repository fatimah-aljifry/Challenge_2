//
//  DayStatus.swift
//  Challenge_2
//

import Foundation

/// What the user did on a given day.
enum DayStatus: String, Codable {
    /// Logged as learned: adds 1 to the streak.
    case learned
    /// Frozen: keeps the streak alive but doesn't add to it.
    case frozen
}
