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
    case typing
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
            Tab(value: .mnemonics, content: {
                NavigationStack {
                    KanaMnemonicsPage()
                }
            }, label: {
                Label(.mnemonics, systemImage: "brain")
            })

            Tab(value: .training, content: {
                NavigationStack(path: rootKanaCoordinator.binding(for: \.path)) {
                    KanaSelectionPage()
                        .registerDestinations()
                }
                .environment(rootKanaCoordinator)
            }, label: {
                Label(.training, systemImage: "figure.run")
            })

//            Tab(value: .learn, content: {
//                NavigationStack(path: rootLearnCoordinator.binding(for: \.path)) {
//                    LearnMainPage()
//                        .registerDestinations()
//                }
//                .environment(rootLearnCoordinator)
//            }, label: {
//                Label(.learn, systemImage: "book")
//            })

            Tab(value: .typing, content: {
                NavigationStack(path: rootTypingCoordinator.binding(for: \.path)) {
                    TypingMenuPage()
                        .registerDestinations()
                }
                .environment(rootTypingCoordinator)
            }, label: {
                Label(.typing, systemImage: "keyboard")
            })

            Tab(value: .about, content: {
                NavigationStack {
                    AboutPage()
                }
            }, label: {
                Label(.about, systemImage: "questionmark.circle")
            })
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
