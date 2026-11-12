//
//  GoalTextField.swift
//  Challenge_2
//

import SwiftUI

/// The underlined "I want to learn" text field, shared by Onboarding and Learning Goal.
struct GoalTextField: View {
    @Binding var text: String
    var placeholder: String = "Swift"

    var body: some View {
        TextField(
            "Learning goal",
            text: $text,
            prompt: Text(placeholder).foregroundStyle(.gray)
        )
        .font(.title3)
        .foregroundStyle(.white)
        .padding(.vertical, 8)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.gray.opacity(0.35))
                .frame(height: 1)
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    GoalTextField(text: $text)
        .padding()
        .background(.black)
}
