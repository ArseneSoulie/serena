//
//  TypingMenuPage.swift
//  Typist
//
//  Created by A S on 16/10/2025.
//

import Navigation
import ReinaDB
import SQLiteData
import SwiftUI

public struct BestScore {
    let kanaOnly: Int = 0
    let easyWords: Int = 0
    let fullDictionnary: Int = 0
}

public struct TypingMenuPage: View {
    @Dependency(\.defaultDatabase) var database

    @Environment(NavigationCoordinator.self) private var coordinator
    @State var bestScore: BestScore = .init()

    @State var randomWord: ReinaWord?

    public init() {}

    public var body: some View {
        ScrollView {
            VStack {
                if let randomWord {
                    Text("Random word: \(randomWord.readings)")
                }

                Text("Get better at typing with a japanese keyboard !")
                Spacer()
                Grid(alignment: .leading, horizontalSpacing: 20) {
                    GridRow {
                        Text("Pick a mode")
                        Text("Top")
                    }
                    GridRow {
                        Button("Kana only", systemImage: "tortoise.fill", action: onKanaOnlyTapped)
                        Text(String(bestScore.kanaOnly))
                    }
                    GridRow {
                        Button("Easy words", systemImage: "cat.fill", action: onEasyWordsTapped)
                        Text(String(bestScore.kanaOnly))
                    }
                    GridRow {
                        Button("Full dictionary", systemImage: "hare.fill", action: onFullDictionnaryTapped)
                        Text(String(bestScore.kanaOnly))
                    }
                }.padding(.horizontal, 8)

                Button("Pick random", action: pickRandomWord)
            }
        }
        .navigationTitle("Typing test")
        .navigationBarTitleDisplayMode(.large)
        .onAppear(perform: pickRandomWord)
    }

    func pickRandomWord() {
        withErrorReporting {
            randomWord = try database.read { db in
                try ReinaWord
                    .where { $0.easinessScore == 8 }
                    .order { _ in #sql("RANDOM()") }
                    .fetchOne(db)
            }
        }
    }

    func onKanaOnlyTapped() {
        coordinator.push(.typing)
    }

    func onEasyWordsTapped() {
        coordinator.push(.typing)
    }

    func onFullDictionnaryTapped() {
        coordinator.push(.typing)
    }
}

#Preview {
    prepareDependenciesForPreview()

    NavigationView {
        TypingMenuPage()
    }.environment(NavigationCoordinator())
}

func prepareDependenciesForPreview() -> some View {
    prepareReinaDB(at: DatabaseLocator.reinaDatabaseURL)
    return EmptyView()
}
