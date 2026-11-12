//
//  OnboardingViewModel.swift
//  Challenge_2
//

import Foundation
import Observation

/// Holds what the user enters on the onboarding screen and starts their first goal.
@MainActor
@Observable
final class OnboardingViewModel {
    /// What the user types in "I want to learn".
    var topic = ""
    /// Week is picked by default; the user can change it.
    var selectedDuration: GoalDuration? = .week

    /// "Start learning" is only enabled when a topic (not just spaces) and a duration are set.
    var canStart: Bool {
        !topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedDuration != nil
    }

    /// Saves the first goal and the registration date.
    func startLearning(in store: LearningStore) {
        guard canStart, let selectedDuration else { return }
        store.startGoal(topic: topic, duration: selectedDuration)
    }
}
