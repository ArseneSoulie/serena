import KanjiVGParser
import SwiftUI

struct MnemonicView: View {
    @Bindable var mnemonicsManager: KanaMnemonicsManager

    let color: Color
    let showGlyphBehindMnemonic: Bool
    let onDrawMnemonicTapped: (KanaMnemonicData) -> Void

    let mnemonicLineStyle: StrokeStyle = .init(lineWidth: 6, lineCap: .round, lineJoin: .round)
    let mnemonicDrawingStyle: StrokeStyle = .init(lineWidth: 2, lineCap: .round, lineJoin: .round)

    let mnemonic: KanaMnemonicData

    var body: some View {
        VStack(alignment: .leading) {
            Text(mnemonic.kanaString)
                .typography(.title2).bold()
                .foregroundStyle(color)
            Text(localized("Mnemonics.\(mnemonic.kanaString)"))
            let currentMnemonic = mnemonicsManager.userMnemonics[mnemonic.kanaString]
            if let personalMnemonic = currentMnemonic?.writtenMnemonic, !personalMnemonic.isEmpty {
                Text(personalMnemonic).foregroundStyle(.secondary)
            }

            HStack(alignment: .center) {
                let url = Bundle.module.url(forResource: "0\(mnemonic.unicodeID)", withExtension: "svg")

                Image("KanaMnemonics/\(mnemonic.unicodeID)", bundle: Bundle.module)
                    .resizable()
                    .frame(width: 200, height: 100)

                if
                    let kanaCustomMnemonic = currentMnemonic?.drawingMnemonic, !kanaCustomMnemonic.isEmpty,
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
