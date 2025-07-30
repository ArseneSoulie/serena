import SwiftUI

enum Tabs: String, CaseIterable {
    case study
    case dictionnary
    case stats
}

public struct ContentView: View {
    @State var selectedTab: Tabs = .study
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            Tab(
                "Dictionnary",
                systemImage: "character.book.closed.fill",
                value: .dictionnary
            ) {
                DictionnaryView()
            }
            Tab(
                "Study",
                systemImage: "book.pages",
                value: .study
            ) {
                StudyView()
            }
            Tab(
                "Stats",
                systemImage: "chart.pie",
                value: .stats
            ) {
                Text("Settings")
            }
        }
    }
}

#Preview {
    ContentView()
}
