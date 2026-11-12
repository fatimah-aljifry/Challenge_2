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
        VStack(spacing: 0) {
            icon
                .accessibilityHidden(true)
                .padding(.bottom, 20)

            Text(isSuccess ? "Well done!" : "You didn't reach your goal this time.")
                .font(.headline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.bottom, 6)

            Text(isSuccess ? "Ready for your next goal?" : "Want to set another goal?")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)

            // Same large gap on both versions, as in the design.
            Button(action: onSetNewGoal) {
                buttonLabel
            }
            .buttonStyle(.glassProminent)
            .tint(.orange)
            .controlSize(.large)
            .padding(.top, 90)
        }
        .padding(.horizontal)
    }

    /// Pencil symbol on the far left, then the title.
    private var buttonLabel: some View {
        Label("Set a goal", systemImage: "pencil.and.outline")
    }

    /// Custom icons from the asset catalog: clapping on success, crossed seal otherwise.
    private var icon: some View {
        Image(isSuccess ? "clapping" : "goalMissed")
            .resizable()
            .scaledToFit()
            .frame(width: 44, height: 44)
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
