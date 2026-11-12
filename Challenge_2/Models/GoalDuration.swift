//
//  GoalDuration.swift
//  Challenge_2
//

import Foundation

/// How long the user wants to spend learning their topic.
enum GoalDuration: String, Codable, CaseIterable, Identifiable {
    case week
    case month
    case year

    var id: Self { self }

    /// Text shown on the Week / Month / Year buttons.
    var title: String {
        switch self {
        case .week: "Week"
        case .month: "Month"
        case .year: "Year"
        }
    }

    /// How many days the user can freeze during one goal of this length.
    var freezeLimit: Int {
        switch self {
        case .week: 2
        case .month: 8
        case .year: 96
        }
    }

    /// The moment a goal of this length ends, counted from its start date.
    func endDate(from startDate: Date, calendar: Calendar = .current) -> Date {
        let component: Calendar.Component = switch self {
        case .week: .weekOfYear
        case .month: .month
        case .year: .year
        }
        return calendar.date(byAdding: component, value: 1, to: startDate) ?? startDate
    }
}
