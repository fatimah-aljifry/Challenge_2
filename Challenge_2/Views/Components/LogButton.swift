//
//  LogButton.swift
//  Challenge_2
//

import SwiftUI

/// The two looks of the big circle on the Activity screen.
enum LogButtonState {
    /// Today isn't logged yet: orange, tappable.
    case ready
    /// Today was logged (learned or frozen): gray, not tappable.
    case logged
}

/// The big "Log as Learned" circle. Orange when tappable, gray once today is logged.
struct LogButton: View {
    let state: LogButtonState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            label
        }
        .buttonStyle(.plain)
        .background {
            Circle()
                .fill(fill)
                .stroke(Color.white.opacity(state == .ready ? 0 : 0.1), lineWidth: 1)
        }
        .glassEffect(glass, in: Circle())
        .disabled(state != .ready)
    }

    private var label: some View {
        // Kept on one horizontal line; shrinks slightly instead of wrapping.
        Text(state == .ready ? "Log as Learned" : "Logged as Learned")
            .font(.title3.bold())
            .foregroundStyle(state == .ready ? .white : .gray)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding(.horizontal, 24)
            .frame(width: 300, height: 300)
            .contentShape(Circle())
    }

    /// Orange interactive glass while tappable. Once logged, glass is turned off
    /// so the dark gray `fill` and its gray text show clearly.
    private var glass: Glass {
        state == .ready ? .regular.tint(.orange).interactive() : .identity
    }

    /// Solid dark gray once logged, so it stays dark on the black screen.
    private var fill: Color {
        state == .ready ? .clear : Color(white: 0.11)
    }
}

#Preview {
    VStack(spacing: 24) {
        LogButton(state: .ready) {}
        LogButton(state: .logged) {}
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.black)
}
