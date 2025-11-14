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
            Section {
                KeyboardStatusView(isInstalled: isKeyboardInstalled)
            } header: {
                Text(.keyboardSetup)
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
                Text(.pickAMode)
            }
            .disabled(!isKeyboardInstalled)
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

struct TypingModeRow: View {
    let level: TypingLevel
    let score: Int

    var body: some View {
        HStack {
            Image(systemName: level.systemImage)
                .typography(.title2)
                .foregroundStyle(.tint)
                .frame(width: 40)

            Text(level.title)

            Spacer()

            Text(String(score))
                .typography(.body)
                .foregroundStyle(.secondary)
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

    var systemImage: String {
        switch self {
        case .kanaOnly: "tortoise.fill"
        case .easyWords: "cat.fill"
        case .fullDictionary: "hare.fill"
        }
    }
}

struct KeyboardStatusView: View {
    let isInstalled: Bool

    var body: some View {
        GroupBox {
            if isInstalled {
                successView
            } else {
                instructionsView
            }
        }
    }

    private var successView: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
            Text(.japaneseKeyboardReady)
            Spacer()
        }
    }

    private var instructionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                Text(.japaneseKeyboardMissingTitle)
                    .typography(.headline)
            }

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
