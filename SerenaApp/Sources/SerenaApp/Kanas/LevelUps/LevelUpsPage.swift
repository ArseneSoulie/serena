import SwiftUI

enum Level {
    case level1
    case level2
    case level3
    case level4
    case completed
}

struct LevelUpsPage: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    let kanaType: KanaType
    let allKanas: [String]
    
    @State var kanaPool: [String]
    @State var level: Level = .level1
    
    init(kanas: [String], kanaType: KanaType) {
        self.allKanas = kanas
        self.kanaType = kanaType
        kanaPool = Array(allKanas.shuffled().prefix(10))
    }
    
    func onLevelCompleted() {
        switch level {
        case .level1: level = .level2
        case .level2: level = .level3
        case .level3: level = .level4
        case .level4: level = .completed
        case .completed: break
        }
    }
    
    var body: some View {
        ZStack {
            switch level {
            case .level1:
                PickAnswerPage(
                    title: "Level 1",
                    pickingExerciceType: .pickRomaji,
                    kanaType: kanaType,
                    kanaPool: kanaPool,
                    onLevelCompleted: onLevelCompleted
                )
            case .level2:
                PickAnswerPage(
                    title: "Level 2",
                    pickingExerciceType: .pickKana,
                    kanaType: kanaType,
                    kanaPool: kanaPool,
                    onLevelCompleted: onLevelCompleted
                )
            case .level3:
                WriteAnswerPage(
                    title: "Level 3",
                    kanaType: kanaType,
                    writingExerciceType: .single,
                    kanaPool: kanaPool,
                    onLevelCompleted: onLevelCompleted
                )
            case .level4:
                WriteAnswerPage(
                    title: "Level 4",
                    kanaType: kanaType,
                    writingExerciceType: .groupOfThree,
                    kanaPool: kanaPool,
                    onLevelCompleted: onLevelCompleted
                )
            case .completed:
                CompletedPage(
                    onTryAgainTapped: restart,
                    onAllInARowTapped: onAllInARowTapped,
                    onGoBackTapped: onGoBackTapped
                )
            }
        }
//        .overlay(alignment: .top) { confettiView.ignoresSafeArea().offset(y: -100) }
    }
    
    func restart() {
        level = .level1
        kanaPool = Array(allKanas.shuffled().prefix(10))
    }
    
    func onAllInARowTapped() {
        coordinator.push(.allInARow(allKanas))
    }
    
    func onGoBackTapped() {
        coordinator.pop()
    }
}
