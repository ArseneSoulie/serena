//
//  ContentView.swift
//  serena
//
//  Created by A S on 23/07/2025.
//

import SwiftUI

enum Tabs: String, CaseIterable {
    case study
    case dictionnary
    case stats
}

struct ContentView: View {
    @State var selectedTab: Tabs = .study
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(
                "Dictionnary",
                systemImage: "character.book.closed.fill",
                value: .dictionnary
            ) {
                Text("Dictionnary")
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
