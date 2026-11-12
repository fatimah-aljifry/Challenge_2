//
//  FreezeButton.swift
//  Challenge_2
//

import SwiftUI

/// The blue button under the big circle.
///
/// Disabled when:
/// - all freezes for the goal are used, or
/// - today is already logged (learned or frozen).
/// It turns back on at 12 AM, because `todayStatus` is `nil` again for the new day.
struct FreezeButton: View {
    /// How today was logged, or `nil` if it wasn't logged yet.
    let todayStatus: DayStatus?
    let freezesRemaining: Int
    let action: () -> Void

    private var isEnabled: Bool {
        todayStatus == nil && freezesRemaining > 0
    }

    var body: some View {
        Button(action: action) {
            Text(todayStatus == .frozen ? "Freezed for a day" : "Freeze for a day")
                .frame(width: 240)
        }
        .buttonStyle(.glassProminent)
        .tint(.cyan)
        .font(.title3)
        .fontWeight(.medium)
        .controlSize(.extraLarge)
        .disabled(!isEnabled)
    }
}

#Preview {
    VStack(spacing: 24) {
        FreezeButton(todayStatus: nil, freezesRemaining: 2) {}      // enabled
        FreezeButton(todayStatus: .frozen, freezesRemaining: 1) {}  // frozen today
        FreezeButton(todayStatus: .learned, freezesRemaining: 1) {} // learned today
        FreezeButton(todayStatus: nil, freezesRemaining: 0) {}      // all freezes used
    }
    .padding()
    .background(.black)
}
