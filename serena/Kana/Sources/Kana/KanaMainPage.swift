import Navigation
import SwiftUI

public struct KanaMainPage: View {
    @Environment(NavigationCoordinator.self) private var coordinator

    public init() {}

    public var body: some View {
        NavigationStack(path: coordinator.binding(for: \.path)) {
            TabView {
                NavigationView {
                    KanaMnemonicsPage()
                }
                .tabItem {
                    Image(systemName: "brain")
                    Text("Mnemonics").typography(.caption)
                }

                NavigationView {
                    KanaLearningPage()
                }
                .tabItem {
                    Image(systemName: "book")
                    Text("Learning").typography(.caption)
                }

                NavigationView {
                    KanaSelectionPage()
                }
                .tabItem {
                    Image(systemName: "figure.run")
                    Text("Training").typography(.caption)
                }
            }
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

#Preview {
    KanaMainPage()
        .environment(NavigationCoordinator())
}
