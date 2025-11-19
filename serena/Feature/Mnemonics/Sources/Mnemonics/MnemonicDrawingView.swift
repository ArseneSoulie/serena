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
                        DrawingView(finishedPaths: $drawnPaths) {
                            strokes?.stroke(lineWidth: 30)
                                .foregroundStyle(Color(white: 0.95))
                                .aspectRatio(1, contentMode: .fit)
                                .padding(48)
                                .frame(maxWidth: 400)
                        }
                        Divider()
                            .padding()
                        Text(.writeWhatTheKanaRemindsYouOf)
                            .typography(.headline)
                        TextField(
                            .explanation,
                            text: $explanationText,
                            prompt: Text(.itRemindsMeOf),
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
            .navigationTitle(.drawYourMnemonicFor(data.kanaString))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(.save, systemImage: "checkmark.circle", action: onSave)
                }
            }
        }
        .onAppear {
            let currentMnemonic = mnemonicsManager.userMnemonics[data.kanaString]
            explanationText = currentMnemonic?.writtenMnemonic ?? ""
            if let currentDrawing = currentMnemonic?.drawingMnemonic, let currentPath = Path(currentDrawing) {
                drawnPaths = [currentPath]
            }
        }
    }

    func onSave() {
        let combinedPaths = Path { path in
            for drawnPath in drawnPaths {
                path.addPath(drawnPath)
            }
        }

        mnemonicsManager.updateMnemonic(
            for: data.kanaString,
            written: explanationText,
            drawing: drawnPaths.isEmpty ? nil : combinedPaths.description,
        )

        dismiss()
    }
}
