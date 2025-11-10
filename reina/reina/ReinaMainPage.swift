import Kana
import Navigation
import SwiftUI
import Typist

enum SelectedTab {
    case mnemonics
    case training
    case typist
    case about
}

public struct ReinaMainPage: View {
    @State var selectedTab: SelectedTab = .training
    let rootKanaCoordinator = NavigationCoordinator()
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
