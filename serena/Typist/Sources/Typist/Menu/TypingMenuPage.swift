//
//  TypingMenuPage.swift
//  Typist
//
//  Created by A S on 16/10/2025.
//

import FoundationModels
import Navigation
import ReinaDB
import Sharing
import SQLiteData
import SwiftUI

public struct TypingMenuPage: View {
    @Dependency(\.defaultDatabase) var database
    @Shared(.appStorage("typingScore")) var typingScore: [TypingLevel: Int] = [:]

    @Environment(NavigationCoordinator.self) private var coordinator

    public init() {}

    public var body: some View {
        ScrollView {
            VStack {
                Text(.getBetterAtTypingWithAJapaneseKeyboard)
                Spacer()
                Grid(alignment: .leading, horizontalSpacing: 20) {
                    GridRow {
                        Text(.pickAMode)
                        Text(.bestScore)
                    }
                    GridRow {
                        Button(.kanaOnly, systemImage: "tortoise.fill", action: onKanaOnlyTapped)
                        Text(String(typingScore[.kanaOnly] ?? 0))
                    }
                    GridRow {
                        Button(.easyWords, systemImage: "cat.fill", action: onEasyWordsTapped)
                        Text(String(typingScore[.easyWords] ?? 0))
                    }
                    GridRow {
                        Button(.fullDictionary, systemImage: "hare.fill", action: onFullDictionnaryTapped)
                        Text(String(typingScore[.fullDictionnary] ?? 0))
                    }
                }.padding(.horizontal, 8)
            }
        }
        .navigationTitle(.typingTest)
        .navigationBarTitleDisplayMode(.large)
    }

    func onKanaOnlyTapped() {
        coordinator.push(.typing(.kanaOnly))
    }

    func onEasyWordsTapped() {
        coordinator.push(.typing(.easyWords))
    }

    func onFullDictionnaryTapped() {
        coordinator.push(.typing(.fullDictionnary))
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
