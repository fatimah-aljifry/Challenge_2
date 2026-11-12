//
//  GoalCompletedView.swift
//  Challenge_2
//

import SwiftUI

/// Replaces the log / freeze buttons once the goal's time is up.
struct GoalCompletedView: View {
    /// `.completed` shows "Well done!", anything else shows "You didn't reach your goal".
    let outcome: GoalOutcome
    let onSetNewGoal: () -> Void

    private var isSuccess: Bool { outcome == .completed }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: isSuccess ? "hands.clap.fill" : "xmark.circle")
                .font(.system(size: 44))
                .foregroundStyle(.orange)
                .accessibilityHidden(true)

            Text(isSuccess ? "Well done!" : "You didn't reach your goal this time.")
                .font(.title2.bold())
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text(isSuccess ? "Goal completed! Set a new learning goal to keep going." : "Want to set another goal?")
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)

            Button("Set new goal", action: onSetNewGoal)
                .buttonStyle(.glassProminent)
                .tint(.orange)
                .font(.title3)
                .fontWeight(.medium)
                .controlSize(.large)
                .padding(.top, 12)
        }
        .padding(.horizontal)
    }
}

#Preview("Completed") {
    GoalCompletedView(outcome: .completed) {}
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
}

#Preview("Missed") {
    GoalCompletedView(outcome: .missed) {}
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
}
