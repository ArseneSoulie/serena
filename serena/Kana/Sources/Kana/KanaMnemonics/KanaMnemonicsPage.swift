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

    @State var searchText: String = ""

    @State var kanaType: KanaType = .hiragana

    @State var showGlyphBehindMnemonic: Bool = false

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        Text(
                            localized(
                                "Here's a list of helpful mnemonics and explanations for each kana we've prepared for you.\nThe best remains for you to make them your own so have fun and experiment by creating your own story !",
                            ),
                        )
                        Divider()

                        ForEach(kanaType.mnemonicGroups, id: \.title) { mnemonicGroup in
                            MnemonicSection(
                                kanaMnemonicsPaths: kanaMnemonicsPaths,
                                kanaMnemonicsExplanations: kanaMnemonicsExplanations,
                                group: mnemonicGroup,
                                showGlyphBehindMnemonic: showGlyphBehindMnemonic,
                                onDrawMnemonicTapped: onDrawMnemonicTapped,
                            )
                        }
                    }
                    .padding()
                    .onChange(of: searchText) { _, newValue in
                        if
                            let match = kanaType.mnemonicGroups.flatMap(\.searchableIds)
                                .first(where: { $0.standardisedRomaji == newValue.standardisedRomaji }) {
                            withAnimation {
                                proxy.scrollTo(match, anchor: .top)
                            }
                        }
                    }
                }
            }
            Picker(localized("Kana"), selection: $kanaType) {
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
            Toggle(localized("Show kana behind drawing"), isOn: $showGlyphBehindMnemonic)
        })
        .navigationTitle(localized("Mnemonics"))
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: localized("Search a kana"),
        )
    }

    func onDrawMnemonicTapped(mnemonic: KanaMnemonicData) {
        presentedMnemonic = mnemonic
    }
}

extension MnemonicGroup {
    var searchableIds: [String] {
        [title] + data.map(\.kanaString)
    }
}

#Preview {
    NavigationStack {
        KanaMnemonicsPage()
    }
}
