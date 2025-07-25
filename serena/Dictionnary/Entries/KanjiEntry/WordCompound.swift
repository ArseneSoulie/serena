import SwiftUI

enum WordCompoundKind {
    case kunyomi
    case onyomi
}

struct WordCompound: Identifiable, Equatable {
    let kind: WordCompoundKind
    let word: String
    let reading: String
    let meanings: [String]
    
    var id: String { word }
}

struct WordCompoundListView: View {
    let title: String
    let compounds: [WordCompound]
    @State private var showDetails = true
    @Environment(\.showFurigana) var showFurigana
    @Environment(\.useKatakanaForOnyomi) var useKatakanaForOnyomi
    
    var body: some View {
        DisclosureGroup(title, isExpanded: $showDetails) {
            Spacer()
            Grid(verticalSpacing: 6) {
                ForEach(compounds) { compound in
                    GridRow(alignment: .center) {
                        let meaningsString = compound.meanings.joined(separator: ", ")
                        VStack() {
                            if showFurigana {
                                OnyomiTextView(compound.reading)
                                    .font(.caption2)
                                    .lineHeight(.tight)
                                    .foregroundColor(.gray)
                                    .environment(\.useKatakanaForOnyomi, compound.kind == .onyomi ? useKatakanaForOnyomi : false)
                            }
                            Button(compound.word) { }.buttonStyle(TileButtonStyle(tileKind: .vocabulary))
                        }.gridColumnAlignment(.trailing)
                        Text(meaningsString)
                    }
                    if compound != compounds.last {
                        Divider()
                    }
                }.gridColumnAlignment(.leading)
            }
        }
    }
}
