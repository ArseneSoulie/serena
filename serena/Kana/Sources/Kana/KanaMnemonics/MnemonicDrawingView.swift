import KanjiVGParser
import SwiftUI

struct MnemonicDrawingView: View {
    let data: KanaMnemonicData
    @Bindable var mnemonicsManager: KanaMnemonicsManager

    @Environment(\.dismiss) var dismiss

    @State var explanationText: String = ""
    @State var drawnPaths: [Path] = []

    var strokes: KanjiStrokes? {
        let url = Bundle.module.url(forResource: "0\(data.unicodeID)", withExtension: "svg")
        return KanjiStrokes(from: url)
    }

    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 16) {
                        DrawingView(
                            finishedPaths: $drawnPaths,
                            contentView: {
                                strokes?.stroke(lineWidth: 30)
                                    .foregroundStyle(Color(white: 0.95))
                                    .aspectRatio(1, contentMode: .fit)
                                    .padding(48)
                            },
                        )
                        Divider()
                            .padding()
                        Text(localized("Write what the kana reminds you of"))
                            .typography(.headline)
                        TextField(
                            localized("Explanation"),
                            text: $explanationText,
                            prompt: Text(localized("It reminds me of...")),
                            axis: .vertical,
                        )
                        .lineLimit(1 ... 5)
                        .focused($isFocused)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .onChange(of: explanationText) { _, newValue in
                            if newValue.contains(where: \.isNewline) {
                                explanationText = explanationText.trimmingCharacters(in: .whitespacesAndNewlines)
                                isFocused = false
                            }
                        }
                    }
                }
                .padding(24)
            }
            .navigationTitle(localized("Draw your mnemonic for %@", data.kanaString))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(localized("Save"), systemImage: "checkmark.circle", action: onSave)
                }
            }
        }
        .onAppear {
            let currentMnemonic = mnemonicsManager.userMnemonics.mnemonics[data.kanaString]
            explanationText = currentMnemonic?.writtenMnemonic ?? ""
            if let currentPath = Path(currentMnemonic?.drawingMnemonic ?? "") {
                drawnPaths = [currentPath]
            }
        }
    }

    func onSave() {
        let pathToSave = Path { path in
            for drawnPath in drawnPaths {
                path.addPath(drawnPath)
            }
        }
        let simplified = pathToSave.description
            .replacingOccurrences(of: #"(\d+)\.\d+"#, with: "$1", options: .regularExpression)

        mnemonicsManager.updateMnemonic(
            for: data.kanaString,
            written: explanationText,
            drawing: simplified,
        )
        dismiss()
    }
}
