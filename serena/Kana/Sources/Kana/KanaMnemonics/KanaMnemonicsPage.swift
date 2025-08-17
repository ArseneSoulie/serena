import DesignSystem
import FoundationModels
import KanjiVGParser
import SwiftUI

public struct KanaMnemonicsPage: View {
    @State private var presentedMnemonic: KanaMnemonicData?
    @State private var kanaMnemonicsPaths = UserDefaults.standard
        .dictionary(forKey: "kana-mnemonic-paths") as? [String: String] ?? [:]

    let mnemonicLineStyle: StrokeStyle = .init(lineWidth: 2, lineCap: .round, lineJoin: .round)

    @State var searchText: String = ""

    @State var kanaType: KanaType = .hiragana

    public var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        Text(
                            "Here's a list of helpful mnemonics and explanations for each kana we've prepared for you.\nThe best remains for you to make them your own so have fun and experiment by creating your own story !",
                        )
                        Divider()
                        ForEach(kanaType.mnemonicsData) { mnemonic in
                            Text(mnemonic.kanaString)
                                .typography(.headline)
                                .id(mnemonic)
                            Text(mnemonic.explanation)

                            HStack(alignment: .center) {
                                let url = Bundle.module.url(forResource: mnemonic.kanjivgId, withExtension: "svg")

                                KanjiStrokes(from: url)?.stroke(style: mnemonicLineStyle)
                                    .frame(width: 50, height: 50)
                                    .padding()

                                let kanaCustomMnemonic = kanaMnemonicsPaths[mnemonic.kanaString]

                                if let kanaCustomMnemonic, let kanaPath = Path(kanaCustomMnemonic) {
                                    ScaledShape(path: kanaPath)
                                        .stroke(style: mnemonicLineStyle)
                                        .frame(width: 50, height: 50)
                                    Button(action: { onDrawMnemonicTapped(mnemonic: mnemonic) }) {
                                        Image(systemName: "pencil")
                                    }
                                } else {
                                    Button(
                                        "Draw your own",
                                        systemImage: "pencil",
                                        action: { onDrawMnemonicTapped(mnemonic: mnemonic) },
                                    )
                                }
                            }
                            Divider()
                        }
                    }
                    .padding()
                    .onChange(of: searchText) { _, newValue in
                        if
                            let match = kanaType.mnemonicsData
                                .first(where: { $0.kanaString.standardisedRomaji == newValue.standardisedRomaji }) {
                            withAnimation {
                                proxy.scrollTo(match, anchor: .top)
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $presentedMnemonic) { data in
            MnemonicDrawingView(data: data, kanaMnemonicsPaths: $kanaMnemonicsPaths)
        }
        .navigationTitle("Mnemonics")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search a kana")
        .toolbar {
            Picker("", selection: $kanaType) {
                ForEach(KanaType.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
        }
    }

    func onDrawMnemonicTapped(mnemonic: KanaMnemonicData) {
        presentedMnemonic = mnemonic
    }
}

struct MnemonicDrawingView: View {
    let data: KanaMnemonicData
    @Binding var kanaMnemonicsPaths: [String: String]
    @Environment(\.dismiss) var dismiss

    @State var drawnPaths: [Path]

    let strokes: KanjiStrokes?

    init(
        data: KanaMnemonicData,
        kanaMnemonicsPaths: Binding<[String: String]>,
    ) {
        self.data = data
        _kanaMnemonicsPaths = kanaMnemonicsPaths

        let url = Bundle.module.url(forResource: data.kanjivgId, withExtension: "svg")
        strokes = KanjiStrokes(from: url)
        if
            let savedDrawing = kanaMnemonicsPaths.wrappedValue[data.kanaString],
            let combinedSavedPaths = Path(savedDrawing) {
            drawnPaths = [combinedSavedPaths]
        } else {
            drawnPaths = []
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                DrawingView(
                    finishedPaths: $drawnPaths,
                    contentView: {
                        strokes?.stroke(lineWidth: 15)
                            .foregroundStyle(Color(white: 0.8))
                            .aspectRatio(1, contentMode: .fit)
                            .padding(48)
                    },
                )
            }
            .navigationTitle("Draw your mnemonic for \(data.kanaString)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "checkmark.circle", action: onSave)
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

        kanaMnemonicsPaths[data.kanaString] = pathToSave.description
        UserDefaults.standard.set(kanaMnemonicsPaths, forKey: "kana-mnemonic-paths")
        dismiss()
    }
}

#Preview {
    NavigationStack {
        KanaMnemonicsPage()
    }
}
