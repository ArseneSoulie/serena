import DesignSystem
import KanjiVGParser
import SwiftUI

struct MnemonicView: View {
    @Bindable var mnemonicsManager: KanaMnemonicsManager

    let mnemonic: KanaMnemonicData
    let color: Color
    let onDrawMnemonicTapped: (KanaMnemonicData) -> Void

    let mnemonicLineStyle: StrokeStyle = .init(lineWidth: 10, lineCap: .butt, lineJoin: .round)
    let mnemonicDrawingStyle: StrokeStyle = .init(lineWidth: 2, lineCap: .round, lineJoin: .round)

    var strokeURL: URL? { Bundle.module.url(forResource: "0\(mnemonic.unicodeID)", withExtension: "svg") }
    var currentMnemonic: UserKanaMnemonic? { mnemonicsManager.userMnemonics[mnemonic.kanaString] }
    var currentExplanation: String? { currentMnemonic?.writtenMnemonic }
    var currentDrawing: String? { currentMnemonic?.drawingMnemonic }

    var body: some View {
        VStack(alignment: .leading) {
            Text(mnemonic.kanaString)
                .typography(.title2)
                .bold()
                .foregroundStyle(color)

            Text(localized("Mnemonics.\(mnemonic.kanaString)"))

            if let currentExplanation, !currentExplanation.isEmpty {
                Text(currentExplanation).foregroundStyle(.secondary)
            }

            HStack {
                HStack {
                    Image("KanaMnemonics/\(mnemonic.unicodeID)", bundle: Bundle.module)
                        .resizable()
                        .frame(width: 200, height: 100)
                    KanjiStrokes(from: strokeURL)?
                        .stroke(style: mnemonicLineStyle)
                        .fill(Color.black.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .overlay {
                            if let currentDrawing, !currentDrawing.isEmpty, let kanaPath = Path(currentDrawing) {
                                kanaPath
                                    .applying(CGAffineTransform.identity.scaledBy(x: 100, y: 100))
                                    .applying(CGAffineTransform.identity.translatedBy(x: -10, y: -10))
                                    .stroke(style: mnemonicDrawingStyle)
                            }
                        }
                }
                .padding()
                .foregroundStyle(.black)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            Button(
                (currentDrawing ?? "").isEmpty ? localized("Draw your own") : localized("Edit"),
                systemImage: "pencil",
                action: { onDrawMnemonicTapped(mnemonic) },
            )
            Divider()
        }
    }
}
