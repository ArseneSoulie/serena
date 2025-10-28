import DesignSystem
import FoundationModels
import KanjiVGParser
import SwiftUI

public struct KanaMnemonicsPage: View {
    @State private var presentedMnemonic: KanaMnemonicData?
    @State private var mnemonicsManager = KanaMnemonicsManager()
    private let audioManager = KanaAudioManager()

    @State var searchText: String = ""

    @State var kanaType: KanaType = .hiragana

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(.ReinaEmotes.mnemonics)
                                .resizable()
                                .frame(width: 64, height: 64)
                            Text(
                                .heresAListOfHelpfulMnemonicsAndExplanationsWevePreparedForYouTheBestRemainsForYouToMakeThemYourOwnSoHaveFunAndExperimentByCreatingYourOwnStory,
                            )
                        }

                        Divider()

                        ForEach(kanaType.mnemonicGroups, id: \.title) { mnemonicGroup in
                            VStack(alignment: .leading) {
                                Text(mnemonicGroup.title)
                                    .typography(.title).bold()
                                    .foregroundStyle(mnemonicGroup.color)
                                ForEach(mnemonicGroup.data, id: \.kanaString) { mnemonic in
                                    MnemonicView(
                                        mnemonicsManager: mnemonicsManager,
                                        audioManager: audioManager,
                                        mnemonic: mnemonic,
                                        color: mnemonicGroup.color,
                                        onDrawMnemonicTapped: onDrawMnemonicTapped,
                                    ).id(mnemonic.kanaString.standardisedRomaji)
                                }
                            }
                        }
                    }
                    .padding()
                    .onChange(of: searchText) { _, newValue in
                        let allKanas = kanaType.mnemonicGroups.flatMap(\.data).map(\.kanaString.standardisedRomaji)
                        if
                            let match = allKanas
                                .first(where: { $0.contains(newValue.standardisedRomaji) }) {
                            withAnimation {
                                proxy.scrollTo(match, anchor: .top)
                            }
                        }
                    }
                }
            }
            Picker(.kana, selection: $kanaType) {
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
                mnemonicsManager: mnemonicsManager,
            )
        }
        .navigationTitle(.mnemonics)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: .searchAKana,
        )
        .onAppear {
            mnemonicsManager.load()
        }
    }

    func onDrawMnemonicTapped(mnemonic: KanaMnemonicData) {
        presentedMnemonic = mnemonic
    }
}

#Preview {
    NavigationStack {
        KanaMnemonicsPage()
    }
}
