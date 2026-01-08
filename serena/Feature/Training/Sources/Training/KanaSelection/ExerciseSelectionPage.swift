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

extension [Kana] {
    var modeString: String {
        let hiraganaCount = filter(\.isHiragana).count
        if hiraganaCount == count {
            return String(localized: .hiragana)
        } else if hiraganaCount == 0 {
            return String(localized: .katakana)
        } else {
            return String(localized: .both)
        }
    }
}

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
                Text(.exerciceSelectionSubtitle(kanaCount: kanaPool.count, kanaMode: kanaPool.modeString))
                    .padding()
                ExerciceBanner(
                    explanation: .levelUpsExplanation,
                    imageResource: ._TrainingBanner.levelUp,
                    bgTint: .blue,
                    onBannerTapped: onLevelUpsTapped,
                )

                ExerciceBanner(
                    explanation: .tryToGetAllSelectedKanasRightInARow,
                    imageResource: ._TrainingBanner.allInARow,
                    bgTint: .red,
                    onBannerTapped: onAllInARowTapped,
                )
            }
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(.default)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
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
    let explanation: LocalizedStringResource
    let imageResource: ImageResource
    let bgTint: Color
    let onBannerTapped: () -> Void

    var body: some View {
        Button(action: onBannerTapped) {
            VStack(alignment: .leading, spacing: 16) {
                Image(imageResource)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(.default)
                HStack {
                    Text(explanation)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .padding()
                }
            }
        }
        .frame(maxWidth: 600)
        .foregroundStyle(.primary)
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground).mix(with: bgTint, by: 0.3))
        .cornerRadius(.default)
    }
}
