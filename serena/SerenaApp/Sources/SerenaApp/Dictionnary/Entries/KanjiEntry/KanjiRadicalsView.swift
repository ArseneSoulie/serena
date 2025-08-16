import SwiftUI

struct KanjiRadicalsView: View {
    let title: String
    let radicals: [String]

    var body: some View {
        HStack {
            Text(title).foregroundStyle(.secondary)
            if radicals.count == 0 {
                Text("-").foregroundStyle(.secondary)
            }
            ForEach(radicals, id: \.self) {
                Button($0) {}.buttonStyle(TileButtonStyle(tileKind: .radical))
            }
        }
    }
}
