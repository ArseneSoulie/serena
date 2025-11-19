import Kana
import Navigation
import SwiftUI

enum Tabs: String, CaseIterable {
    case study
    case dictionary
    case stats
    case testing
}

public struct ContentView: View {
    @State var selectedTab: Tabs = .dictionary

    var coordinator = NavigationCoordinator()

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            Tab(
                "Dictionary",
                systemImage: "character.book.closed.fill",
                value: .dictionary,
            ) {
                DictionaryView()
            }
            Tab(
                "Study",
                systemImage: "book.pages",
                value: .study,
            ) {
                StudyView()
            }
            Tab(
                "Stats",
                systemImage: "chart.pie",
                value: .stats,
            ) {
                Text("Settings")
            }
        }
    }
}

#Preview {
    ContentView()
}
