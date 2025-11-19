import SwiftUI

struct KanjiMeaningsView: View {
    let title: String
    let meanings: Meanings

    var body: some View {
        HStack {
            Text(title).foregroundStyle(.secondary)
            if meanings.jishoMeanings.count + meanings.userProvidedMeanings.count == 0 {
                Text("-").foregroundStyle(.secondary)
            }
            Text(meanings.jishoMeanings.joined(separator: ", "))
            Text(meanings.userProvidedMeanings.joined(separator: ", ")).italic()
        }
    }
}
