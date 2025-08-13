import SwiftUI
import Navigation
import FoundationModels

public struct AllInARowPage: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    
    let kanas: [Kana]
    
    @State private var failedKanas: Set<Kana> = []
    @State private var remainingKanas: Set<Kana>
    
    @State var isFinished: Bool = false
    
    public init(kanas: [Kana]) {
        self.kanas = kanas
        self.remainingKanas = Set(kanas)
    }
    
    
    public var body: some View {
        if !isFinished {
            AllInARowExercicePage(
                kanas: kanas,
                failedKanas: $failedKanas,
                remainingKanas: $remainingKanas,
                onFinished: onFinished
            )
        } else {
            CompletedAllInARowPage(
                kanas: kanas,
                failedKanas: failedKanas,
                remainingKanas: remainingKanas,
                onTryAgainTapped: onTryAgainTapped,
                onLevelUpsTapped: onLevelUpsTapped,
                onGoBackTapped: onGoBackTapped
            )
        }
    }
    
    func onFinished() {
        withAnimation {
            isFinished = true
        }
    }
    
    func onTryAgainTapped() {
        withAnimation {
            isFinished = false
            failedKanas.removeAll()
            remainingKanas = Set(kanas)
        }
    }
    
    func onLevelUpsTapped() {
        coordinator.push(.levelUps(kanas))
    }
    
    func onGoBackTapped() {
        coordinator.popToRoot()
    }
}


