import KanjiVGParser
import SwiftUI

struct MnemonicSection: View {
    @Bindable var mnemonicsManager: KanaMnemonicsManager

    let group: MnemonicGroup
    let showGlyphBehindMnemonic: Bool
    let onDrawMnemonicTapped: (KanaMnemonicData) -> Void

    let mnemonicLineStyle: StrokeStyle = .init(lineWidth: 6, lineCap: .round, lineJoin: .round)
    let mnemonicDrawingStyle: StrokeStyle = .init(lineWidth: 2, lineCap: .round, lineJoin: .round)

    var body: some View {
        VStack(alignment: .leading) {
            Text(group.title)
                .typography(.title).bold()
                .id(group.title)
                .foregroundStyle(group.color)
            ForEach(group.data) { mnemonic in
                Text(mnemonic.kanaString)
                    .typography(.title2).bold()
                    .id(mnemonic)
                    .foregroundStyle(group.color)
                Text(localized("Mnemonics.\(mnemonic.kanaString)"))
                let currentMnemonic = mnemonicsManager.userMnemonics[mnemonic.kanaString]
                if let personalMnemonic = currentMnemonic?.writtenMnemonic {
                    Text(personalMnemonic).foregroundStyle(.secondary)
                }

                HStack(alignment: .center) {
                    let url = Bundle.module.url(forResource: "0\(mnemonic.unicodeID)", withExtension: "svg")

                    Image("KanaMnemonics/\(mnemonic.unicodeID)", bundle: Bundle.module)
                        .resizable()
                        .frame(width: 200, height: 100)

                    if
                        let kanaCustomMnemonic = currentMnemonic?.drawingMnemonic,
                        let kanaPath = Path(kanaCustomMnemonic) {
                        ZStack {
                            if showGlyphBehindMnemonic {
                                KanjiStrokes(from: url)?.stroke(style: mnemonicLineStyle)
                                    .fill(Color.primary.opacity(0.1))
                            }
                            ScaledShape(path: kanaPath).stroke(style: mnemonicDrawingStyle)
                        }
                        .frame(width: 80, height: 80)
                        Button(action: { onDrawMnemonicTapped(mnemonic) }) {
                            Image(systemName: "pencil")
                        }
                    } else {
                        Button(
                            localized("Draw your own"),
                            systemImage: "pencil",
                            action: { onDrawMnemonicTapped(mnemonic) },
                        )
                    }
                }
                Divider()
            }
        }
    }
}
