import FoundationModels
import Navigation
import SwiftUI

enum AllInARowState {
    case exercice(kanas: [Kana])
    case summary(kanas: [KanaWithCompletionState])
}

public struct AllInARowPage: View {
    @Environment(NavigationCoordinator.self) private var coordinator

    let kanas: [Kana]

    @State var allInARowState: AllInARowState

    init(kanas: [Kana]) {
        self.kanas = kanas
        allInARowState = .exercice(kanas: kanas)
    }

    public var body: some View {
        switch allInARowState {
        case let .exercice(kanas):
            AllInARowExercicePage(
                kanas: kanas,
                onFinishedExercice: onFinishedExercice,
            )
        case let .summary(kanas):
            CompletedAllInARowPage(
                kanasWithCompletionState: kanas,
                onTryAgainTapped: onTryAgainTapped,
                onLevelUpsTapped: onLevelUpsTapped,
                onGoBackTapped: onGoBackTapped,
            )
        }
    }

    func onFinishedExercice(result: AllInARowResult) {
        withAnimation {
            let kanasWithStates: [KanaWithCompletionState] =
                result.successKanas.map { .init(kana: $0, completionState: .success) }
                    + result.skippedKanas.map { .init(kana: $0, completionState: .skipped) }
                    + result.failedKanas.map { .init(kana: $0, completionState: .failed) }

            allInARowState = .summary(kanas: kanasWithStates)
        }
    }

    func onTryAgainTapped() {
        withAnimation {
            allInARowState = .exercice(kanas: kanas)
        }
    }

    func onLevelUpsTapped() {
        coordinator.push(.levelUps(kanas))
    }

    func onGoBackTapped() {
        coordinator.popToRoot()
    }
}

struct AllInARowResult {
    let successKanas: [Kana]
    let skippedKanas: [Kana]
    let failedKanas: [Kana]
}
