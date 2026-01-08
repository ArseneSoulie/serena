import About
import Learn
import Mnemonics
import Navigation
import SwiftUI
import Training
import Typist

enum SelectedTab {
    case mnemonics
    case training
    case learn
    case typist
    case about
}

public struct ReinaMainPage: View {
    @State var selectedTab: SelectedTab = .training
    let rootKanaCoordinator = NavigationCoordinator()
    let rootLearnCoordinator = NavigationCoordinator()
    let rootTypingCoordinator = NavigationCoordinator()

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            Tab(
                String(localized: .mnemonics),
                systemImage: "brain",
                value: .mnemonics,
            ) {
                NavigationStack {
                    KanaMnemonicsPage()
                }
            }

            Tab(
                String(localized: .training),
                systemImage: "figure.run",
                value: .training,
            ) {
                NavigationStack(path: rootKanaCoordinator.binding(for: \.path)) {
                    KanaSelectionPage()
                        .registerDestinations()
                }
                .environment(rootKanaCoordinator)
            }
//
//            Tab(
//                String(localized: .learn),
//                systemImage: "book",
//                value: .learn,
//            ) {
//                NavigationStack(path: rootLearnCoordinator.binding(for: \.path)) {
//                    LearnMainPage()
//                        .registerDestinations()
//                }
//                .environment(rootLearnCoordinator)
//            }

            Tab(
                String(localized: .typing),
                systemImage: "keyboard",
                value: .typist,
            ) {
                NavigationStack(path: rootTypingCoordinator.binding(for: \.path)) {
                    TypingMenuPage()
                        .registerDestinations()
                }
                .environment(rootTypingCoordinator)
            }

            Tab(
                String(localized: .about),
                systemImage: "questionmark.circle",
                value: .about,
            ) {
                NavigationStack {
                    AboutPage()
                }
            }
        }
        .registerFontForSwiftUIComponents()
    }
}

extension View {
    func registerDestinations() -> some View {
        navigationDestination(for: Destination.self) { destination in
            switch destination {
            case let .levelUps(kanas):
                LevelUpsPage(kanas: kanas)
            case let .allInARow(kanas):
                AllInARowPage(kanas: kanas)
            case let .exerciseSelection(kanas):
                ExerciseSelectionPage(kanaPool: kanas)
            case let .typing(level):
                TypingPage(level: level)
            case let .learn(learnCategory):
                switch learnCategory {
                case .commonConfusions:
                    CommonConfusionsPage()
                case .digital:
                    DigitalPage()
                case .grammar:
                    GrammarPage()
                case .kanji:
                    KanjiPage()
                case .rabbitHole:
                    RabbitHolePage()
                case .readingSpeaking:
                    ReadingSpeakingPage()
                case .starting:
                    StartingPage()
                }
            }
        }
    }
}

#Preview {
    ReinaMainPage()
}
