import Navigation
import SwiftUI

enum SelectedTab {
    case mnemonics
    case training
}

public struct KanaMainPage: View {
    @Environment(NavigationCoordinator.self) private var coordinator

    @State var selectedTab: SelectedTab = .training

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
                NavigationStack(path: coordinator.binding(for: \.path)) {
                    KanaSelectionPage()
                        .navigationDestination(for: Destination.self) { destination in
                            switch destination {
                            case let .levelUps(kanas):
                                LevelUpsPage(kanas: kanas)
                            case let .allInARow(kanas):
                                AllInARowPage(kanas: kanas)
                            case let .exerciseSelection(kanas):
                                ExerciseSelectionPage(kanaPool: kanas)
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    KanaMainPage()
        .environment(NavigationCoordinator())
}
