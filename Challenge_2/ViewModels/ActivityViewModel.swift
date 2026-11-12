//
//  ActivityViewModel.swift
//  Challenge_2
//

import Foundation
import Observation

/// Turns the store's data into exactly what the Activity screen shows,
/// and forwards the screen's taps to the store.
@MainActor
@Observable
final class ActivityViewModel {
    /// The current moment as far as the screen knows. Updated by `refresh()`,
    /// so the date, week strip and buttons move to the next day at midnight.
    private(set) var now: Date

    @ObservationIgnored private let store: LearningStore
    @ObservationIgnored private let calendar: Calendar

    init(store: LearningStore, calendar: Calendar = .current, now: Date = .now) {
        self.store = store
        self.calendar = calendar
        self.now = now
    }

    // MARK: - Header and week strip

    /// Today's real date, e.g. "Thursday, 12 November" (order follows the user's region).
    var headerDate: String {
        now.formatted(.dateTime.weekday(.wide).day().month(.wide))
    }

    /// The 7 days of the current week, starting on the user's first weekday.
    var currentWeek: [Date] {
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }
    }

    /// How a day appears in the week strip (learned wins over frozen).
    func status(for date: Date) -> DayStatus? {
        store.status(for: date)
    }

    // MARK: - Stat cards

    /// "1 day" / "3 days" for the 🔥 card.
    var streakText: String { dayText(store.streakCount) }

    /// "1 day" / "0 days" for the ❄️ card.
    var freezeText: String { dayText(store.freezesUsed) }

    // MARK: - Buttons

    /// How today was logged for the current goal; `nil` means both buttons are available.
    var todayStatus: DayStatus? { store.todayStatus(now: now) }

    var logButtonState: LogButtonState { todayStatus == nil ? .ready : .logged }

    var freezesRemaining: Int { store.freezesRemaining }

    /// e.g. "1 out of 2 Freezes used", using the user's real limit (2 / 8 / 96).
    var freezeFooter: String {
        let limit = store.goal?.duration.freezeLimit ?? 0
        return "\(store.freezesUsed) out of \(limit) Freezes used"
    }

    /// In progress → buttons; completed / missed → "Well done!" or "You didn't reach your goal".
    var outcome: GoalOutcome { store.outcome(now: now) }

    // MARK: - Actions

    /// `date` defaults to the real current time; passing a date lets the rules be checked with made-up times.
    func logLearned(at date: Date = .now) {
        refresh(at: date)
        store.log(.learned, now: date)
    }

    func freezeToday(at date: Date = .now) {
        refresh(at: date)
        store.log(.frozen, now: date)
    }

    /// Moves the screen to the current time and applies the 32-hour rule.
    /// Called on appear, when the app returns to the foreground, and at `nextRefreshDate`.
    func refresh(at date: Date = .now) {
        now = date
        store.checkStreak(now: date)
    }

    /// The next moment the screen must update by itself:
    /// midnight (new day → buttons back on) or the moment the streak runs out, whichever is first.
    var nextRefreshDate: Date {
        let startOfToday = calendar.startOfDay(for: now)
        let midnight = calendar.date(byAdding: .day, value: 1, to: startOfToday) ?? now.addingTimeInterval(3600)
        guard let deadline = store.streakDeadline, deadline > now else { return midnight }
        return min(midnight, deadline)
    }

    // MARK: - Helpers

    /// "1 day" when the number is 1, otherwise "N days" (lowercase, as in the design).
    private func dayText(_ count: Int) -> String {
        count == 1 ? "1 day" : "\(count) days"
    }
}
