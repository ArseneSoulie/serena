import DesignSystem
import FoundationModels
import KanjiVGParser
import SwiftUI

public struct KanaMnemonicsPage: View {
    @StateObject private var mnemonicsManager = KanaMnemonicsManager()
    @State private var presentedMnemonic: KanaMnemonicData?
    private let audioManager = KanaAudioManager()

    @State private var searchText: String = ""
    @State private var kanaType: KanaType = .hiragana
    @State private var showInfo: Bool = false

    private var searchableKanas: [String] {
        kanaType.mnemonicGroups.flatMap(\.data).map(\.kanaString.standardisedRomaji)
    }

    public init() {}

    public var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(kanaType.mnemonicGroups, id: \.title) { mnemonicGroup in
                    Section {
                        ForEach(mnemonicGroup.data, id: \.kanaString) { mnemonic in
                            MnemonicView(
                                mnemonicsManager: mnemonicsManager,
                                audioManager: audioManager,
                                mnemonic: mnemonic,
                                color: mnemonicGroup.color,
                                onDrawMnemonicTapped: onDrawMnemonicTapped,
                            )
                            .id(mnemonic.kanaString.standardisedRomaji)
                            .buttonStyle(.plain)
                        }
                    } header: {
                        if let title = mnemonicGroup.title {
                            Text(title)
                                .typography(.title).bold()
                                .foregroundStyle(mnemonicGroup.color)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .onChange(of: searchText) { _, newValue in
                if
                    let match = searchableKanas
                        .first(where: { $0.contains(newValue.standardisedRomaji) }) {
                    withAnimation {
                        proxy.scrollTo(match, anchor: .top)
                    }
                }
            }
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
        .toolbar {
            Picker(.kana, selection: $kanaType) {
                ForEach(KanaType.allCases, id: \.self) { kanaSelectionType in
                    Label(kanaSelectionType.localizedResource, systemImage: "arrow.up.arrow.down")
                        .typography(.body)
                        .modify {
                            if kanaType == kanaSelectionType {
                                $0.labelStyle(.titleAndIcon)
                            } else {
                                $0.labelStyle(.titleOnly)
                            }
                        }
                }
            }
            .fixedSize()
            .pickerStyle(.menu)
            Button("", systemImage: "info.circle", action: { showInfo.toggle() })
        }
        .overlay(alignment: .top) {
            Color(.clear).frame(height: 0)
                .popover(
                    isPresented: $showInfo,
                ) {
                    PageInfoView(
                        infoPages: [
                            .mnemonicsExplanation1,
                            .mnemonicsExplanation2,
                            .mnemonicsExplanation3,
                        ],
                        image: ._ReinaEmotes.mnemonics,
                    )
                }
        }
    }

    func onDrawMnemonicTapped(mnemonic: KanaMnemonicData) {
        presentedMnemonic = mnemonic
    }
}

extension KanaType {
    var localizedResource: LocalizedStringResource {
        switch self {
        case .hiragana:
            .hiragana
        case .katakana:
            .katakana
        }
    }
}

#Preview {
    NavigationStack {
        KanaMnemonicsPage()
    }
}
