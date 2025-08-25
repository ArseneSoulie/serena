import SwiftUI

typealias UserKanaMnemonics = [String: UserKanaMnemonic]

@Observable
class KanaMnemonicsManager: ObservableObject {
    var userMnemonics: UserKanaMnemonics = [:]

    private let fileName = "UserKanaMnemonics.json"

    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(fileName)
    }

    init() {
        load()
    }

    func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode(UserKanaMnemonics.self, from: data)
            userMnemonics = decoded
        } catch {
            print("Failed to load mnemonics: \(error)")
            userMnemonics = [:]
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(userMnemonics)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to save mnemonics: \(error)")
        }
    }

    func updateMnemonic(for kana: String, written: String?, drawing: String?) {
        userMnemonics[kana] = .init(
            writtenMnemonic: written,
            drawingMnemonic: drawing,
        )
        save()
    }
}
