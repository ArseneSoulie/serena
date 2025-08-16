import SwiftUI

struct KanjiSimilarView: View {
    let title: String
    let similarKanji: [String]

    var body: some View {
        HStack {
            Text(title).foregroundStyle(.secondary)
            if similarKanji.count == 0 {
                Text("-").foregroundStyle(.secondary)
            }
            ForEach(similarKanji, id: \.self) {
                Button($0) {}.buttonStyle(TileButtonStyle(tileKind: .kanji))
            }
        }
    }
}
