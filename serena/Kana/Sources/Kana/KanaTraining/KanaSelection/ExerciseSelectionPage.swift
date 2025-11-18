//
//  ExerciseSelectionPage.swift
//  Kana
//
//  Created by A S on 11/08/2025.
//

import DesignSystem
import FoundationModels
import Navigation
import SwiftUI

public struct ExerciseSelectionPage: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(NavigationCoordinator.self) private var coordinator

    let kanaPool: [Kana]

    public init(kanaPool: [Kana]) {
        self.kanaPool = kanaPool
    }

    public var body: some View {
        ScrollView(.vertical) {
            VStack {
                VStack {
                    Text(.levelUps)
                        .typography(.title2)
                    ExerciceBanner(
                        title: .levelUpsExplanation,
                        imageResource: ._TrainingBanner.levelUp,
                        onBannerTapped: onLevelUpsTapped,
                    )
                }

                Divider().padding(.top)

                VStack {
                    Text(.allInARow)
                        .typography(.title2)
                    ExerciceBanner(
                        title: .tryToGetAllSelectedKanasRightInARow,
                        imageResource: ._TrainingBanner.allInARow,
                        onBannerTapped: onAllInARowTapped,
                    )
                }
            }
            .padding(.horizontal)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle(.pickAnExerciseType)
    }

    func onLevelUpsTapped() {
        coordinator.push(.levelUps(kanaPool))
    }

    func onAllInARowTapped() {
        coordinator.push(.allInARow(kanaPool))
    }
}

#Preview {
    ExerciseSelectionPage(kanaPool: [])
        .environment(NavigationCoordinator())
}

struct ExerciceBanner: View {
    let title: LocalizedStringResource
    let imageResource: ImageResource
    let onBannerTapped: () -> Void

    var body: some View {
        Button(action: onBannerTapped) {
            VStack(spacing: 16) {
                Image(imageResource)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(.default)
                HStack {
                    Text(title)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .padding()
                }
            }
            .padding()
        }
        .frame(maxWidth: 500)
        .foregroundStyle(.primary)
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(.default)
    }
}
