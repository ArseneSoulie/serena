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
    @Environment(\.scenePhase) private var scenePhase

    @State private var isKeyboardInstalled: Bool = false

    public init() {}

    public var body: some View {
        List {
            if !isKeyboardInstalled {
                Section {
                    KeyboardInstructionsView()
                } header: {
                    Text(.keyboardSetup)
                }
            }

            Section {
                Text(.typingExplanation)
            }

            Section {
                ForEach(TypingLevel.allCases, id: \.self) { level in
                    Button(action: {
                        coordinator.push(.typing(level))
                    }) {
                        TypingModeRow(level: level, score: typingScore[level] ?? 0)
                    }
                    .foregroundStyle(.primary)
                }
            } header: {
                HStack {
                    Text(.pickAMode)
                    Spacer()
                    Text(.bestScore)
                }
            }
            .disabled(!isKeyboardInstalled)

            Section {
                KeyboardInfoView(
                    title: .kanaKeyboard,
                    explanation: .kanaKeyboardExplanation,
                    image: ._Typing.Tutorial.kana,
                )
                KeyboardInfoView(
                    title: .qwertyKeyboard,
                    explanation: .qwertyKeyboardExplanation,
                    image: ._Typing.Tutorial.qwerty,
                )
                KeyboardInfoView(
                    title: .handwritingKeyboard,
                    explanation: .handwritingKeyboardExplanation,
                    image: ._Typing.Tutorial.hand,
                )
            } header: {
                Text(.keyboardTypes)
            }
        }
        .navigationTitle(.typingTest)
        .onAppear {
            checkKeyboardStatus()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                checkKeyboardStatus()
            }
        }
    }

    func onKanaOnlyTapped() {
        coordinator.push(.typing(.kanaOnly))
    }

    func onEasyWordsTapped() {
        coordinator.push(.typing(.easyWords))
    }

    func onFullDictionaryTapped() {
        coordinator.push(.typing(.fullDictionary))
    }

    func checkKeyboardStatus() {
        isKeyboardInstalled = KeyboardUtilities.isJapaneseKeyboardInstalled()
    }
}

struct KeyboardInfoView: View {
    let title: LocalizedStringResource
    let explanation: LocalizedStringResource
    let image: ImageResource

    var body: some View {
        VStack {
            Text(title)
                .typography(.headline)
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 500)
            Text(explanation)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.secondary)
        }
    }
}

struct TypingModeRow: View {
    let level: TypingLevel
    let score: Int

    var body: some View {
        HStack {
            Image(level.imageResource)
                .resizable()
                .typography(.title2)
                .foregroundStyle(.tint)
                .frame(width: 48, height: 48)

            Text(level.title)

            Spacer()

            Text(String(score))
                .typography(.body)
                .foregroundStyle(.secondary)
            Image(systemName: "chevron.right")
        }
        .padding(.vertical, 4)
    }
}

extension TypingLevel {
    var title: LocalizedStringResource {
        switch self {
        case .kanaOnly: .kanaOnly
        case .easyWords: .easyWords
        case .fullDictionary: .fullDictionary
        }
    }

    var imageResource: ImageResource {
        switch self {
        case .kanaOnly: ._ReinaEmotes.easy
        case .easyWords: ._ReinaEmotes.medium
        case .fullDictionary: ._ReinaEmotes.hard
        }
    }
}

struct KeyboardInstructionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                Text(.japaneseKeyboardMissingTitle)
                    .typography(.headline)
            }
            Image(._ReinaEmotes.confused)
                .resizable()
                .frame(width: 64, height: 64)
                .frame(maxWidth: .infinity)

            Text(.japaneseKeyboardMissingInstructions)

            Button(.openSettings, systemImage: "gear", action: KeyboardUtilities.openSettings)
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
        }
    }
}

@MainActor
enum KeyboardUtilities {
    /// Checks all active input modes to see if a Japanese keyboard is enabled.
    static func isJapaneseKeyboardInstalled() -> Bool {
        UITextInputMode.activeInputModes.contains {
            $0.primaryLanguage?.contains("ja") == true
        }
    }

    /// Opens the main iOS Settings app.
    static func openSettings() {
        guard
            let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url)
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
