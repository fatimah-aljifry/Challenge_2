//
//  WeekStripView.swift
//  Challenge_2
//

import SwiftUI

/// The row of 7 days at the top of the Activity screen.
struct WeekStripView: View {
    /// The 7 dates to show, in order. Supplied by the ViewModel.
    let days: [Date]
    let today: Date
    /// Looks up how each day was logged (comes from the store).
    let status: (Date) -> DayStatus?

    var body: some View {
        HStack(spacing: 0) {
            ForEach(days, id: \.self) { day in
                VStack(spacing: 8) {
                    Text(day, format: .dateTime.weekday(.abbreviated))
                        .font(.caption.weight(.semibold))
                        .textCase(.uppercase)
                        .foregroundStyle(.gray)
                        .accessibilityHidden(true)

                    DayCircle(
                        date: day,
                        status: status(day),
                        isToday: Calendar.current.isDate(day, inSameDayAs: today)
                    )
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    let calendar = Calendar.current
    let today = Date.now
    let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
    let days = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }

    WeekStripView(days: days, today: today) { day in
        switch calendar.component(.weekday, from: day) {
        case 1, 2: .learned
        case 3: .frozen
        default: nil
        }
    }
    .padding()
    .background(.black)
}
