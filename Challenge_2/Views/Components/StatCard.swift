//
//  StatCard.swift
//  Challenge_2
//

import SwiftUI

/// A small card showing one number, e.g. "4 Days / Learned" or "1 Day / Freezed".
struct StatCard: View {
    let systemImage: String
    let tint: Color
    /// Already formatted by the ViewModel, e.g. "1 Day" or "4 Days".
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(tint)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 70)
        // Solid dark tint instead of glass: tinted glass looks washed out on the black screen.
        .background(tint.opacity(0.2), in: .rect(cornerRadius: 34))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    HStack {
        StatCard(systemImage: "flame.fill", tint: .orange, value: "4 Days", label: "Learned")
        StatCard(systemImage: "snowflake", tint: .cyan, value: "1 Day", label: "Freezed")
    }
    .padding()
    .background(.black)
}
