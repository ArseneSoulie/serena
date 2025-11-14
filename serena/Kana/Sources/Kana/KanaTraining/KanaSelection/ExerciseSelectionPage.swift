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
        List {
            Section(.levelUps) {
                ExerciceBanner(
                    title: .levelUpsExplanation,
                    imageResource: .TrainingBanner.levelUp,
                    onBannerTapped: onLevelUpsTapped,
                )
            }

            Section(.allInARow) {
                ExerciceBanner(
                    title: .tryToGetAllSelectedKanasRightInARow,
                    imageResource: .TrainingBanner.allInARow,
                    onBannerTapped: onAllInARowTapped,
                )
            }
        }.navigationTitle(.pickAnExerciseType)
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
            VStack(alignment: .leading, spacing: 16) {
                Image(imageResource)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(.default)
                HStack {
                    Text(title).multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .padding()
                }
            }
            .padding()
        }
        .foregroundStyle(.primary)
    }
}
