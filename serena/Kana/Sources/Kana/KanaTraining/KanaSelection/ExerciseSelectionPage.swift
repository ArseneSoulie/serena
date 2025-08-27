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

    let kanaPool: [Kana]

    public init(kanaPool: [Kana]) {
        self.kanaPool = kanaPool
    }

    public var body: some View {
        ScrollView {
            if horizontalSizeClass == .compact {
                VStack(alignment: .leading) {
                    SelectionContent(kanaPool: kanaPool)
                }
                .padding()
            } else {
                HStack {
                    SelectionContent(kanaPool: kanaPool)
                }.padding()
            }
        }.navigationTitle(localized("Pick an exercise type"))
    }
}

#Preview {
    ExerciseSelectionPage(kanaPool: [])
        .environment(NavigationCoordinator())
}

struct ExerciceBanner: View {
    let title: String
    let imageResource: ImageResource
    let onBannerTapped: () -> Void

    var body: some View {
        Button(action: onBannerTapped) {
            VStack(alignment: .leading, spacing: 16) {
                Image(imageResource)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                HStack {
                    Text(title).multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .padding()
                }
            }
            .padding()
            .background(.quinary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .foregroundStyle(.primary)
    }
}

struct SelectionContent: View {
    @Environment(NavigationCoordinator.self) private var coordinator

    let kanaPool: [Kana]

    var body: some View {
        VStack {
            Text(localized("Level ups"))
                .typography(.title2)

            ExerciceBanner(
                title: localized("Learn the selected kanas by doing challenges of increasing difficulty"),
                imageResource: .TrainingBanner.levelUp,
                onBannerTapped: onLevelUpsTapped,
            )
            .padding(.horizontal, 8)
        }

        Divider()
        VStack {
            Text(localized("All in a row"))
                .typography(.title2)

            ExerciceBanner(
                title: localized("Try to get all selected kanas right in a row !"),
                imageResource: .TrainingBanner.allInARow,
                onBannerTapped: onAllInARowTapped,
            )
            .padding(.horizontal, 8)
        }
    }

    func onLevelUpsTapped() {
        coordinator.push(.levelUps(kanaPool))
    }

    func onAllInARowTapped() {
        coordinator.push(.allInARow(kanaPool))
    }
}
