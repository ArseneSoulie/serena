import DesignSystem
import SwiftUI

public struct KanjiPage: View {
    public init() {}

    public var body: some View {
        List {
            Section {
                Text("What are Kanji and why do we need them?")
                Text("Onyomi? Kunyomi? What's the difference?")
                Text("What are Furigana? (The tiny kana above Kanji)")
                Text("What are Okurigana? (The kana attached to Kanji)")
                Text("How to write Japanese characters? (Stroke order)")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Into the World of Kanji")
    }
}

#Preview {
    NavigationView {
        KanjiPage()
    }
}
