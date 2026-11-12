//
//  MonthGridView.swift
//  Challenge_2
//

import SwiftUI

/// One month in the Calendar: title, weekday header and a 7-column grid of days.
/// View-only: days can't be tapped.
struct MonthGridView: View {
    /// Any date inside the month (used for the "January 2026" title).
    let month: Date
    /// The grid cells, supplied by the ViewModel. `nil` = empty cell before the 1st.
    let days: [Date?]
    let today: Date
    let status: (Date) -> DayStatus?

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(month, format: .dateTime.month(.wide).year())
                .font(.title3.bold())
                .foregroundStyle(.white)

            LazyVGrid(columns: columns, spacing: 8) {
                // Header and day cells never reorder, so their position is a stable id.
                ForEach(Array(Calendar.current.orderedShortWeekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                    Text(symbol)
                        .font(.caption.weight(.semibold))
                        .textCase(.uppercase)
                        .foregroundStyle(.gray)
                        .accessibilityHidden(true)
                }

                ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                    if let day {
                        DayCircle(
                            date: day,
                            status: status(day),
                            isToday: Calendar.current.isDate(day, inSameDayAs: today),
                            size: 40
                        )
                    } else {
                        Color.clear
                            .frame(height: 40)
                            .accessibilityHidden(true)
                    }
                }
            }
        }
    }
}

private extension Calendar {
    /// "Sun", "Mon", … starting from the user's first day of the week.
    var orderedShortWeekdaySymbols: [String] {
        let symbols = shortStandaloneWeekdaySymbols
        let start = firstWeekday - 1
        return Array(symbols[start...] + symbols[..<start])
    }
}

#Preview {
    // Builds the cells for the current month the same way the ViewModel will.
    let calendar = Calendar.current
    let today = Date.now
    let monthStart = calendar.dateInterval(of: .month, for: today)?.start ?? today
    let dayCount = calendar.range(of: .day, in: .month, for: monthStart)?.count ?? 30
    let leadingBlanks = (calendar.component(.weekday, from: monthStart) - calendar.firstWeekday + 7) % 7
    let days: [Date?] = Array(repeating: nil, count: leadingBlanks)
        + (0..<dayCount).map { calendar.date(byAdding: .day, value: $0, to: monthStart) }

    MonthGridView(month: monthStart, days: days, today: today) { day in
        let number = calendar.component(.day, from: day)
        if number % 5 == 0 { return .frozen }
        if number < calendar.component(.day, from: today) { return .learned }
        return nil
    }
    .padding()
    .background(.black)
}
