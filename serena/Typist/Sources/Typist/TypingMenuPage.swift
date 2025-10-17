//
//  TypingMenuPage.swift
//  Typist
//
//  Created by A S on 16/10/2025.
//

import Navigation
import SwiftUI

public struct BestScore {
    let kanaOnly: Int = 0
    let easyWords: Int = 0
    let fullDictionnary: Int = 0
}

public struct TypingMenuPage: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @State var bestScore: BestScore = .init()

    public init() {}

    public var body: some View {
        ScrollView {
            VStack {
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
            }
        }
        .navigationTitle("Typing test")
        .navigationBarTitleDisplayMode(.large)
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
    NavigationView {
        TypingMenuPage()
    }.environment(NavigationCoordinator())
}
