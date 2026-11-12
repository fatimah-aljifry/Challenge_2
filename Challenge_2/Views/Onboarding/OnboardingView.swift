//
//  OnboardingView.swift
//  Challenge_2
//
//  Created by Fatimah Aljifry on 28/05/1448 AH.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(LearningStore.self) private var store
    @State private var viewModel = OnboardingViewModel()

    var body: some View {
        VStack {
            Image(systemName: "flame.fill")
                .foregroundStyle(.orange)
                .font(.system(size: 36))
                .scaleEffect(x: -1, y: 1)
                .padding(.bottom, 50)

            HStack {
                Text("Hello")
                    .foregroundStyle(.white)
                    .font(.largeTitle)

                Text("Learner")
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("This app will help you learn everyday!")
                .foregroundStyle(.gray)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 30)

            Text("I want to learn")
                .font(.default)
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            GoalTextField(text: $viewModel.topic)

            Text("I want to learn it in a ")
                .font(.default)
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)

            DurationPicker(selection: $viewModel.selectedDuration)
                .padding(.bottom, 300)

            Button("Start Learning") {
                viewModel.startLearning(in: store)
            }
            .buttonStyle(.glassProminent)
            .font(.title3)
            .tint(.orange)
            .fontWeight(.medium)
            .controlSize(.extraLarge)
            .disabled(!viewModel.canStart)

            Text("You can edit your desire later")
                .foregroundStyle(.gray)
        }
        // Fill the whole screen, then paint it black (extends behind the status bar automatically).
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}

#Preview {
    // A throwaway store so the preview never touches the app's real saved data.
    OnboardingView()
        .environment(LearningStore(defaults: UserDefaults(suiteName: "preview") ?? .standard))
}
