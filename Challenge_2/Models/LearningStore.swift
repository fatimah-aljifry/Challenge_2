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

    /// The UserDefaults key `AppData` is saved under.
    private static let storageKey = "appData"

    private(set) var data: AppData

    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private let calendar: Calendar

    init(defaults: UserDefaults = .standard, calendar: Calendar = .current) {
        self.defaults = defaults
        self.calendar = calendar
        self.data = Self.load(from: defaults)
    }

    // MARK: - Reading

    var goal: LearningGoal? { data.goal }

    var registrationDate: Date? { data.registrationDate }

    /// How a given day was logged, or `nil` if it wasn't. Used by the week strip and the Calendar.
    /// If the day has two logs (goal updated in between), learned wins over frozen.
    func status(for date: Date) -> DayStatus? {
        let dayLogs = data.logs.filter { calendar.isDate($0.day, inSameDayAs: date) }
        if dayLogs.contains(where: { $0.status == .learned }) { return .learned }
        if dayLogs.contains(where: { $0.status == .frozen }) { return .frozen }
        return nil
    }

    /// How today was logged *for the current goal*, or `nil` if the user can still log today.
    /// A log made before the goal was updated doesn't count, so the user can log again.
    func todayStatus(now: Date = .now) -> DayStatus? {
        guard let goalStart = data.goal?.startDate else { return nil }
        return data.logs
            .filter { $0.loggedAt >= goalStart && calendar.isDate($0.day, inSameDayAs: now) }
            .max { $0.loggedAt < $1.loggedAt }?
            .status
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

    /// The moment the current streak will break if nothing is logged (last activity + 32 hours).
    /// The Activity screen uses it to refresh exactly when the streak runs out.
    var streakDeadline: Date? {
        lastActivity.map { $0.addingTimeInterval(Self.streakTimeout) }
    }

    /// Whether the goal is still running, was completed, or was missed.
    ///
    /// - `.completed` as soon as streak days + freeze days equals the goal's length in days
    ///   (e.g. 7 for a week). Since there is one log per day per goal, this happens on the last day's log,
    ///   so "Well done!" shows right away.
    /// - `.missed` at midnight after the last day if that total wasn't reached.
    /// - `.inProgress` otherwise.
    func outcome(now: Date = .now) -> GoalOutcome {
        guard let goal = data.goal else { return .inProgress }

        if streakCount + freezesUsed >= goal.dayCount(calendar: calendar) {
            return .completed
        }
        return goal.hasEnded(at: now, calendar: calendar) ? .missed : .inProgress
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
    /// - Today's *learned* log is kept, so today still shows as learned.
    /// - Today's *freeze* is removed, so today shows as not logged until the new goal logs.
    /// - Earlier days are never touched.
    /// The streak and freezes restart at 0, and the user can log again today for the new goal.
    func updateGoal(topic: String, duration: GoalDuration, now: Date = .now) {
        data.logs.removeAll { $0.status == .frozen && calendar.isDate($0.day, inSameDayAs: now) }
        beginGoal(topic: topic, duration: duration, now: now)
    }

    /// Logs today as learned or frozen. Does nothing if today is already logged for this goal,
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
        let checkDate = min(now, goal.endDate(calendar: calendar))
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

    /// The latest log in the current streak, or the streak's start if there is none.
    private var lastActivity: Date? {
        guard let streakStart = data.streakStartDate else { return nil }
        let lastLog = data.logs
            .filter { $0.loggedAt >= streakStart }
            .map(\.loggedAt)
            .max()
        return lastLog ?? streakStart
    }

    /// True if more than 32 hours passed between the last activity and `date`.
    private func isStreakBroken(at date: Date) -> Bool {
        guard let lastActivity else { return false }
        return date.timeIntervalSince(lastActivity) > Self.streakTimeout
    }

    private func save() {
        guard let encoded = try? JSONEncoder().encode(data) else { return }
        defaults.set(encoded, forKey: Self.storageKey)
    }

    private static func load(from defaults: UserDefaults) -> AppData {
        guard let saved = defaults.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode(AppData.self, from: saved)
        else { return AppData() }
        return decoded
    }
}
