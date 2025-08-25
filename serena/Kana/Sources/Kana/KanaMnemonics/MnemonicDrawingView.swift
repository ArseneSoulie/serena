import KanjiVGParser
import SwiftUI

struct MnemonicDrawingView: View {
    let data: KanaMnemonicData
    @Binding var kanaMnemonicsPaths: [String: String]
    @Binding var kanaMnemonicsExplanations: [String: String]
    @Environment(\.dismiss) var dismiss

    @State var explanationText: String
    @State var drawnPaths: [Path]

    let strokes: KanjiStrokes?

    init(
        data: KanaMnemonicData,
        kanaMnemonicsPaths: Binding<[String: String]>,
        kanaMnemonicsExplanations: Binding<[String: String]>,
    ) {
        self.data = data
        _kanaMnemonicsPaths = kanaMnemonicsPaths
        _kanaMnemonicsExplanations = kanaMnemonicsExplanations

        let url = Bundle.module.url(forResource: "0\(data.unicodeID)", withExtension: "svg")
        strokes = KanjiStrokes(from: url)
        if
            let savedDrawing = kanaMnemonicsPaths.wrappedValue[data.kanaString],
            let combinedSavedPaths = Path(savedDrawing) {
            drawnPaths = [combinedSavedPaths]
        } else {
            drawnPaths = []
        }
        explanationText = kanaMnemonicsExplanations.wrappedValue[data.kanaString] ?? ""
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
    }

    func onSave() {
        let pathToSave = Path { path in
            for drawnPath in drawnPaths {
                path.addPath(drawnPath)
            }
        }
        let simplified = pathToSave.description
            .replacingOccurrences(of: #"(\d+)\.\d+"#, with: "$1", options: .regularExpression)

        kanaMnemonicsPaths[data.kanaString] = simplified
        kanaMnemonicsExplanations[data.kanaString] = explanationText
        UserDefaults.standard.set(kanaMnemonicsPaths, forKey: UserDefaultsKeys.kanaMnemonicsPaths)
        UserDefaults.standard.set(kanaMnemonicsExplanations, forKey: UserDefaultsKeys.kanaMnemonicsExplanations)
        dismiss()
    }
}
