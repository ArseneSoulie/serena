import SwiftUI
import Navigation

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
        withAnimation {
            switch level {
            case .level1: level = .level2
            case .level2: level = .level3
            case .level3: level = .level4
            case .level4: level = .completed
            case .completed: break
            }
        }
    }
    
    var body: some View {
        switch level {
        case .level1:
            PickAnswerPage(
                title: "\(localized("Level")) 1",
                pickingExerciceType: .pickRomaji,
                kanaType: kanaType,
                kanaPool: kanaPool,
                onLevelCompleted: onLevelCompleted
            )
        case .level2:
            PickAnswerPage(
                title: "\(localized("Level")) 2",
                pickingExerciceType: .pickKana,
                kanaType: kanaType,
                kanaPool: kanaPool,
                onLevelCompleted: onLevelCompleted
            )
        case .level3:
            WriteAnswerPage(
                title: "\(localized("Level")) 3",
                kanaType: kanaType,
                writingExerciceType: .single,
                kanaPool: kanaPool,
                onLevelCompleted: onLevelCompleted
            )
        case .level4:
            WriteAnswerPage(
                title: "\(localized("Level")) 4",
                kanaType: kanaType,
                writingExerciceType: .groupOfThree,
                kanaPool: kanaPool,
                onLevelCompleted: onLevelCompleted
            )
        case .completed:
            CompletedLevelUpsPage(
                onTryAgainTapped: restart,
                onAllInARowTapped: onAllInARowTapped,
                onGoBackTapped: onGoBackTapped
            )
        }
    }
    
    func restart() {
        withAnimation {
            level = .level1
            kanaPool = Array(allKanas.shuffled().prefix(10))
        }
    }
    
    func onAllInARowTapped() {
        coordinator.push(.allInARow(allKanas))
    }
    
    func onGoBackTapped() {
        coordinator.popToRoot()
    }
}
