//
//  ActivityView.swift
//  Challenge_2
//
//  Created by Fatimah Aljifry on 29/05/1448 AH.
//

import SwiftUI

/// The main screen: this week's progress, the streak and freeze counts,
/// and the buttons to log today as learned or frozen.
struct ActivityView: View {
    /// Owned by the parent (connected in step 8), so it isn't recreated when this view redraws.
    let viewModel: ActivityViewModel
    /// ✎ pencil and "Set a goal" → Learning Goal page (connected in step 8).
    var onEditGoal: () -> Void = {}
    /// 📅 → Calendar (connected in step 8).
    var onOpenCalendar: () -> Void = {}

    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 0) {
            header

            progressBox
                .padding(.top, 20)

            if viewModel.outcome == .inProgress {
                logSection
            } else {
                Spacer()
                GoalCompletedView(outcome: viewModel.outcome, onSetNewGoal: onEditGoal)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        // Fill the whole screen, then paint it black (extends behind the status bar automatically).
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        // Keeps the screen current while it's open: refreshes now, then sleeps until
        // the next midnight or streak deadline, wakes up, refreshes again, and repeats.
        .task {
            while !Task.isCancelled {
                viewModel.refresh()
                let wait = viewModel.nextRefreshDate.timeIntervalSinceNow
                try? await Task.sleep(for: .seconds(max(1, wait)))
            }
        }
        // Coming back to the app (e.g. the next morning) → update right away.
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                viewModel.refresh()
            }
        }
    }

    // MARK: - Sections

    /// "Activity" title with the edit-goal and calendar buttons, and today's date.
    private var header: some View {
        VStack(spacing: 4) {
            HStack {
                Text("Activity")
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // The title isn't shown (icon only) but VoiceOver reads it.
                Button("Edit learning goal", systemImage: "pencil.and.outline", action: onEditGoal)
                    .modifier(HeaderIconStyle())

                Button("Calendar", systemImage: "calendar", action: onOpenCalendar)
                    .modifier(HeaderIconStyle())
            }

            Text(viewModel.headerDate)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    /// This week's days and the two count cards.
    private var progressBox: some View {
        VStack(spacing: 16) {
            WeekStripView(days: viewModel.currentWeek, today: viewModel.now) { day in
                viewModel.status(for: day)
            }

            HStack(spacing: 12) {
                StatCard(systemImage: "flame.fill", tint: .orange, value: viewModel.streakText, label: "Learned")
                StatCard(systemImage: "snowflake", tint: .cyan, value: viewModel.freezeText, label: "Freezed")
            }
        }
    }

    /// The big circle, the freeze button and the "X out of Y Freezes used" line.
    private var logSection: some View {
        VStack(spacing: 0) {
            Spacer()

            LogButton(state: viewModel.logButtonState) {
                viewModel.logLearned()
            }

            Spacer()

            FreezeButton(todayStatus: viewModel.todayStatus, freezesRemaining: viewModel.freezesRemaining) {
                viewModel.freezeToday()
            }

            Text(viewModel.freezeFooter)
                .font(.footnote)
                .foregroundStyle(.gray)
                .padding(.top, 10)
                .padding(.bottom, 8)
        }
    }

}

/// Shared look for the two round glass buttons in the header.
private struct HeaderIconStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .labelStyle(.iconOnly)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(.white)
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .controlSize(.large)
    }
}

// MARK: - Previews

/// Builds a throwaway store with a goal and some logs, so each preview shows a different state.
/// `daysAgo` = how many days before today the goal started; `logs` = (days ago, status).
@MainActor
private func previewViewModel(
    _ name: String,
    duration: GoalDuration = .week,
    startedDaysAgo daysAgo: Int,
    logs: [(daysAgo: Int, status: DayStatus)]
) -> ActivityViewModel {
    let defaults = UserDefaults(suiteName: "preview-\(name)") ?? .standard
    defaults.removePersistentDomain(forName: "preview-\(name)")
    let store = LearningStore(defaults: defaults)
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: .now)
    func day(_ ago: Int, hour: Int) -> Date {
        calendar.date(byAdding: .hour, value: hour, to: calendar.date(byAdding: .day, value: -ago, to: today) ?? today) ?? today
    }
    store.startGoal(topic: "Swift", duration: duration, now: day(daysAgo, hour: 0))
    for log in logs {
        store.log(log.status, now: day(log.daysAgo, hour: 9))
    }
    return ActivityViewModel(store: store)
}

#Preview("Ready to log") {
    ActivityView(viewModel: previewViewModel("ready", startedDaysAgo: 2, logs: [(2, .learned), (1, .frozen)]))
        .preferredColorScheme(.dark)
}

#Preview("Logged today") {
    ActivityView(viewModel: previewViewModel("logged", startedDaysAgo: 2, logs: [(2, .learned), (1, .learned), (0, .learned)]))
        .preferredColorScheme(.dark)
}

#Preview("Frozen today") {
    ActivityView(viewModel: previewViewModel("frozen", startedDaysAgo: 1, logs: [(1, .learned), (0, .frozen)]))
        .preferredColorScheme(.dark)
}

#Preview("All freezes used") {
    ActivityView(viewModel: previewViewModel("noFreezes", startedDaysAgo: 2, logs: [(2, .frozen), (1, .frozen)]))
        .preferredColorScheme(.dark)
}

#Preview("Well done") {
    // Oldest day first, the same order a real user would log in.
    ActivityView(viewModel: previewViewModel("done", startedDaysAgo: 6, logs: (0...6).reversed().map { ($0, .learned) }))
        .preferredColorScheme(.dark)
}

#Preview("Goal not reached") {
    ActivityView(viewModel: previewViewModel("missed", startedDaysAgo: 8, logs: [(8, .learned), (7, .learned)]))
        .preferredColorScheme(.dark)
}
