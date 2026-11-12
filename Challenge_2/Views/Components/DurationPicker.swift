//
//  DurationPicker.swift
//  Challenge_2
//

import SwiftUI

/// The Week / Month / Year buttons, shared by Onboarding and Learning Goal.
/// `selection` is optional so the Learning Goal page can start with nothing picked.
struct DurationPicker: View {
    @Binding var selection: GoalDuration?

    var body: some View {
        HStack {
            ForEach(GoalDuration.allCases) { duration in
                // The two button styles are different types, so each state gets its own branch.
                if selection == duration {
                    Button(duration.title) { selection = duration }
                        .buttonStyle(.glassProminent)
                        .tint(.orange)
                        .accessibilityAddTraits(.isSelected)
                } else {
                    Button(duration.title) { selection = duration }
                        .buttonStyle(.glass)
                        .foregroundStyle(.white.opacity(0.3))
                }
            }
        }
        .controlSize(.large)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    @Previewable @State var selection: GoalDuration? = .week
    VStack(alignment: .leading, spacing: 24) {
        DurationPicker(selection: $selection)
        DurationPicker(selection: .constant(nil))
    }
    .padding()
    .background(.black)
}
