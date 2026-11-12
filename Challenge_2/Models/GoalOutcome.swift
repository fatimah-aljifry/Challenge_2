//
//  GoalOutcome.swift
//  Challenge_2
//

import Foundation

/// Decides which version of the Activity screen to show.
enum GoalOutcome: Equatable {
    /// The goal's time hasn't run out yet: show the log and freeze buttons.
    case inProgress
    /// Time is up and the streak never broke: show "Well done!".
    case completed
    /// Time is up but the streak broke along the way: show "You didn't reach your goal".
    case missed
}
