import DesignSystem
import FoundationModels
import KanjiVGParser
import SwiftUI

public struct KanaMnemonicsPage: View {
    @State private var presentedMnemonic: KanaMnemonicData?
    @State private var kanaMnemonicsPaths = UserDefaults.standard
        .dictionary(forKey: UserDefaultsKeys.kanaMnemonicsPaths) as? [String: String] ?? [:]
    @State private var kanaMnemonicsExplanations = UserDefaults.standard
        .dictionary(forKey: UserDefaultsKeys.kanaMnemonicsExplanations) as? [String: String] ?? [:]

    let mnemonicLineStyle: StrokeStyle = .init(lineWidth: 6, lineCap: .round, lineJoin: .round)
    let mnemonicDrawingStyle: StrokeStyle = .init(lineWidth: 2, lineCap: .round, lineJoin: .round)

    @State var searchText: String = ""

    @State var kanaType: KanaType = .hiragana

    @State var showGlyphBehindMnemonic: Bool = false

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        Text(
                            "Here's a list of helpful mnemonics and explanations for each kana we've prepared for you.\nThe best remains for you to make them your own so have fun and experiment by creating your own story !",
                        )
                        Divider()
                        ForEach(kanaType.mnemonicsData) { mnemonic in
                            Text(mnemonic.kanaString)
                                .typography(.title2).bold()
                                .id(mnemonic)
                            Text(mnemonic.explanation)
                            if let personalMnemonic = kanaMnemonicsExplanations[mnemonic.kanaString] {
                                Text(personalMnemonic).foregroundStyle(.secondary)
                            }

                            HStack(alignment: .center) {
                                let url = Bundle.module.url(forResource: mnemonic.kanjivgId, withExtension: "svg")

                                KanjiStrokes(from: url)?.stroke(style: mnemonicLineStyle)
                                    .fill(.cyan)
                                    .frame(width: 50, height: 50)
                                    .padding()

                                Image("KanaMnemonics/\(mnemonic.kanaString)", bundle: Bundle.module)
                                    .resizable()
                                    .frame(width: 50, height: 50)

                                let kanaCustomMnemonic = kanaMnemonicsPaths[mnemonic.kanaString]

                                if let kanaCustomMnemonic, let kanaPath = Path(kanaCustomMnemonic) {
                                    ZStack {
                                        if showGlyphBehindMnemonic {
                                            KanjiStrokes(from: url)?.stroke(style: mnemonicLineStyle)
                                                .fill(Color.primary.opacity(0.1))
                                        }
                                        ScaledShape(path: kanaPath).stroke(style: mnemonicDrawingStyle)
                                    }
                                    .frame(width: 50, height: 50)
                                    Button(action: { onDrawMnemonicTapped(mnemonic: mnemonic) }) {
                                        Image(systemName: "pencil")
                                    }
                                } else {
                                    Button(
                                        "Make your own",
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
            Picker("", selection: $kanaType) {
                ForEach(KanaType.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .fixedSize()
            .padding()
        }
        .sheet(item: $presentedMnemonic) { data in
            MnemonicDrawingView(
                data: data,
                kanaMnemonicsPaths: $kanaMnemonicsPaths,
                kanaMnemonicsExplanations: $kanaMnemonicsExplanations,
            )
        }
        .toolbar(content: {
            Toggle("Show kana behind drawing", isOn: $showGlyphBehindMnemonic)
        })
        .navigationTitle("Mnemonics")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search a kana")
    }

    func onDrawMnemonicTapped(mnemonic: KanaMnemonicData) {
        presentedMnemonic = mnemonic
    }
}

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

        let url = Bundle.module.url(forResource: data.kanjivgId, withExtension: "svg")
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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    TextField(
                        "Explanation",
                        text: $explanationText,
                        prompt: Text("It reminds me of..."),
                        axis: .vertical,
                    )
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    DrawingView(
                        finishedPaths: $drawnPaths,
                        contentView: {
                            strokes?.stroke(lineWidth: 30)
                                .foregroundStyle(Color(white: 0.95))
                                .aspectRatio(1, contentMode: .fit)
                                .padding(48)
                        },
                    )
                }
            }
            .navigationTitle("Make your mnemonic for \(data.kanaString)")
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
        let simplified = pathToSave.description
            .replacingOccurrences(of: #"(\d+)\.\d+"#, with: "$1", options: .regularExpression)

        kanaMnemonicsPaths[data.kanaString] = simplified
        kanaMnemonicsExplanations[data.kanaString] = explanationText
        UserDefaults.standard.set(kanaMnemonicsPaths, forKey: UserDefaultsKeys.kanaMnemonicsPaths)
        UserDefaults.standard.set(kanaMnemonicsExplanations, forKey: UserDefaultsKeys.kanaMnemonicsExplanations)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        KanaMnemonicsPage()
    }
}
