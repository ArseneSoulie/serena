import SwiftUI
import Navigation

struct AllInARowPage: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    
    let kanas: [String]
    let kanaType: KanaType
    
    @State private var failedKanas: Set<String> = []
    @State private var remainingKanas: Set<String>
    
    @State var isFinished: Bool = false
    
    init(kanas: [String], kanaType: KanaType) {
        self.kanas = kanas
        self.kanaType = kanaType
        self.remainingKanas = Set(kanas)
    }
    
    
    var body: some View {
        if !isFinished {
            AllInARowExercicePage(
                kanas: kanas,
                kanaType: kanaType,
                failedKanas: $failedKanas,
                remainingKanas: $remainingKanas,
                onFinished: onFinished
            )
        } else {
            CompletedAllInARowPage(
                kanas: kanas,
                kanaType: kanaType,
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


