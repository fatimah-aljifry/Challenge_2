//
//  LearningStore.swift
//  Challenge_2
//

import Foundation
import Observation

/// The single source of truth for the app's data.
/// Owns `AppData`, saves it to UserDefaults, and holds the streak / freeze rules.
/// Every screen's ViewModel reads from and writes through this store.
@MainActor
@Observable
final class LearningStore {
    /// How long the user can go without logging (learned or frozen) before the streak breaks.
    static let streakTimeout: TimeInterval = 32 * 60 * 60

    private(set) var data: AppData

    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private let calendar: Calendar
    @ObservationIgnored private let storageKey = "appData"

    init(defaults: UserDefaults = .standard, calendar: Calendar = .current) {
        self.defaults = defaults
        self.calendar = calendar
        self.data = Self.load(from: defaults, key: "appData")
    }

    // MARK: - Reading

    var goal: LearningGoal? { data.goal }

    var registrationDate: Date? { data.registrationDate }

    /// How a given day was logged, or `nil` if it wasn't. Used by the week strip and the Calendar.
    func status(for date: Date) -> DayStatus? {
        data.logs.first { calendar.isDate($0.day, inSameDayAs: date) }?.status
    }

    /// How today was logged, or `nil` if the user can still log today.
    func todayStatus(now: Date = .now) -> DayStatus? {
        status(for: now)
    }

    /// Learned days since the current streak began.
    var streakCount: Int {
        guard let streakStart = data.streakStartDate else { return 0 }
        return data.logs.filter { $0.status == .learned && $0.loggedAt >= streakStart }.count
    }

    /// Frozen days since the current goal began.
    var freezesUsed: Int {
        guard let goalStart = data.goal?.startDate else { return 0 }
        return data.logs.filter { $0.status == .frozen && $0.loggedAt >= goalStart }.count
    }

    /// Freezes left for the current goal (2 / 8 / 96 minus the ones used).
    var freezesRemaining: Int {
        guard let goal = data.goal else { return 0 }
        return max(0, goal.duration.freezeLimit - freezesUsed)
    }

    /// Whether the goal is still running, or ended with or without the streak intact.
    func outcome(now: Date = .now) -> GoalOutcome {
        guard let goal = data.goal, goal.hasEnded(at: now) else { return .inProgress }
        guard let streakStart = data.streakStartDate else { return .missed }

        // The streak survived only if it was never reset during the goal
        // and it hadn't run out by the time the goal ended.
        let neverReset = streakStart <= goal.startDate
        return neverReset && !isStreakBroken(at: goal.endDate) ? .completed : .missed
    }

    // MARK: - Writing

    /// Called when the user taps "Start learning" in onboarding.
    func startGoal(topic: String, duration: GoalDuration, now: Date = .now) {
        if data.registrationDate == nil {
            data.registrationDate = now
        }
        beginGoal(topic: topic, duration: duration, now: now)
    }

    /// Called when the user confirms "Update" in the Learning Goal alert.
    /// Today's log is removed so the user can log again for the new goal; earlier days are kept.
    func updateGoal(topic: String, duration: GoalDuration, now: Date = .now) {
        data.logs.removeAll { calendar.isDate($0.day, inSameDayAs: now) }
        beginGoal(topic: topic, duration: duration, now: now)
    }

    /// Logs today as learned or frozen. Does nothing if today is already logged,
    /// the goal has ended, or (for a freeze) no freezes are left.
    func log(_ status: DayStatus, now: Date = .now) {
        checkStreak(now: now)

        guard data.goal != nil,
              outcome(now: now) == .inProgress,
              todayStatus(now: now) == nil
        else { return }

        if status == .frozen && freezesRemaining == 0 { return }

        data.logs.append(DayLog(status: status, loggedAt: now, calendar: calendar))
        save()
    }

    /// Resets the streak if more than 32 hours passed without a log.
    /// Call when the app opens, comes back to the foreground, or a new day starts.
    func checkStreak(now: Date = .now) {
        guard let goal = data.goal else { return }

        // Only look at time inside the goal, so the streak can't break after the goal is over.
        let checkDate = min(now, goal.endDate)
        guard isStreakBroken(at: checkDate) else { return }

        data.streakStartDate = checkDate
        save()
    }

    // MARK: - Private helpers

    /// Shared by `startGoal` and `updateGoal`: sets the goal and restarts the streak and freeze count.
    private func beginGoal(topic: String, duration: GoalDuration, now: Date) {
        let trimmedTopic = topic.trimmingCharacters(in: .whitespacesAndNewlines)
        data.goal = LearningGoal(topic: trimmedTopic, duration: duration, startDate: now)
        data.streakStartDate = now
        save()
    }

    /// True if more than 32 hours passed between the last activity and `date`.
    /// "Last activity" is the latest log in the current streak, or the streak's start if there is none.
    private func isStreakBroken(at date: Date) -> Bool {
        guard let streakStart = data.streakStartDate else { return false }
        let lastLog = data.logs
            .filter { $0.loggedAt >= streakStart }
            .map(\.loggedAt)
            .max()
        let lastActivity = lastLog ?? streakStart
        return date.timeIntervalSince(lastActivity) > Self.streakTimeout
    }

    private func save() {
        guard let encoded = try? JSONEncoder().encode(data) else { return }
        defaults.set(encoded, forKey: storageKey)
    }

    private static func load(from defaults: UserDefaults, key: String) -> AppData {
        guard let saved = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode(AppData.self, from: saved)
        else { return AppData() }
        return decoded
    }
}
