import FoundationModels
import Navigation
import SwiftUI

enum AllInARowState {
    case exercice(kanas: [Kana])
    case summary(result: AllInARowResult)
}

public struct AllInARowPage: View {
    @Environment(NavigationCoordinator.self) private var coordinator

    let kanas: [Kana]

    @State var allInARowState: AllInARowState

    public init(kanas: [Kana]) {
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
        case let .summary(result):
            CompletedAllInARowPage(
                result: result,
                onTryAgainTapped: onTryAgainTapped,
                onLevelUpsTapped: onLevelUpsTapped,
                onGoBackTapped: onGoBackTapped,
            )
        }
    }

    func onFinishedExercice(result: AllInARowResult) {
        withAnimation {
            allInARowState = .summary(result: result)
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
