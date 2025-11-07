import Navigation
import SwiftUI
import Typist

enum SelectedTab {
    case mnemonics
    case training
    case typist
}

public struct KanaMainPage: View {
    @State var selectedTab: SelectedTab = .training
    let rootKanaCoordinator = NavigationCoordinator()
    let rootTypingCoordinator = NavigationCoordinator()

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            Tab(
                localized("Mnemonics"),
                systemImage: "brain",
                value: .mnemonics,
            ) {
                NavigationStack {
                    KanaMnemonicsPage()
                }
            }

            Tab(
                localized("Training"),
                systemImage: "figure.run",
                value: .training,
            ) {
                NavigationStack(path: rootKanaCoordinator.binding(for: \.path)) {
                    KanaSelectionPage()
                        .registerDestinations()
                }
                .environment(rootKanaCoordinator)
            }

            Tab(
                localized("Typing"),
                systemImage: "keyboard",
                value: .typist,
            ) {
                NavigationStack(path: rootTypingCoordinator.binding(for: \.path)) {
                    TypingMenuPage()
                        .registerDestinations()
                }
                .environment(rootTypingCoordinator)
            }
        }
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
            }
        }
    }
}

#Preview {
    KanaMainPage()
}
