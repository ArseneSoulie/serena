import Navigation
import SwiftUI

public struct KanaMainPage: View {
    @Environment(NavigationCoordinator.self) private var coordinator

    public init() {}

    public var body: some View {
        TabView {
            NavigationStack {
                KanaMnemonicsPage()
            }
            .tabItem {
                Image(systemName: "brain")
                Text(localized("Mnemonics"))
            }

//                NavigationView {
//                    KanaLearningPage()
//                }
//                .tabItem {
//                    Image(systemName: "book")
//                    Text("Learning")
//                }

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
            .tabItem {
                Image(systemName: "figure.run")
                Text(localized("Training"))
            }
        }
    }
}

#Preview {
    KanaMainPage()
        .environment(NavigationCoordinator())
}
