import FoundationModels
import Navigation
import SwiftUI

public struct KanaSelectionPage: View {
    @Environment(NavigationCoordinator.self) private var coordinator

    @State var selectedBase: Set<KanaLine> = []
    @State var selectedDiacritic: Set<KanaLine> = []
    @State var selectedCombinatory: Set<KanaLine> = []
    @State var selectedCombinatoryDiacritic: Set<KanaLine> = []
    @State var selectedExtendedKatakana: Set<KanaLine> = []

    @State var showRomaji: Bool = false
    @State var showInfo: Bool = false

    @State var kanaSelectionType: KanaSelectionType = .hiragana

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    KanaLineGroupView(
                        title: .base,
                        lines: base,
                        selectedLines: $selectedBase,
                        showRomaji: showRomaji,
                        kanaSelectionType: kanaSelectionType,
                        tint: CatagoryColor.base,
                    )
                    KanaLineGroupView(
                        title: .diacritics,
                        lines: diacritic,
                        selectedLines: $selectedDiacritic,
                        showRomaji: showRomaji,
                        kanaSelectionType: kanaSelectionType,
                        tint: CatagoryColor.diacritic,
                    )
                    KanaLineGroupView(
                        title: .combinatory,
                        lines: combinatory,
                        selectedLines: $selectedCombinatory,
                        showRomaji: showRomaji,
                        kanaSelectionType: kanaSelectionType,
                        tint: CatagoryColor.combinatory,
                    )
                    KanaLineGroupView(
                        title: .combinatoryDiacritics,
                        lines: combinatoryDiacritic,
                        selectedLines: $selectedCombinatoryDiacritic,
                        showRomaji: showRomaji,
                        kanaSelectionType: kanaSelectionType,
                        tint: CatagoryColor.combinarotyDiacritic,
                    )
                    if kanaSelectionType != .hiragana {
                        KanaLineGroupView(
                            title: .extendedKatakana,
                            lines: extendedKatakana,
                            selectedLines: $selectedExtendedKatakana,
                            showRomaji: showRomaji,
                            kanaSelectionType: .katakana,
                            tint: CatagoryColor.extendedKatakana,
                        )
                    }
                }

                Spacer()
                    .frame(height: 160)
            }
        }
        .animation(.default, value: showRomaji)
        .animation(.default, value: kanaSelectionType)
        .overlay(alignment: .bottom) {
            let totalSelectedKanas = selectedKanasForExercise.count
            if totalSelectedKanas != 0 {
                Button(
                    .letsGo(totalSelectedKanas),
                    systemImage: "arrow.right",
                    action: onExerciceSelectionTapped,
                )
                .buttonStyle(.borderedProminent)
                .padding(.all)
            }
        }
        .overlay(alignment: .top) {
            Color(.clear).frame(height: 0)
                .popover(
                    isPresented: $showInfo,
                ) {
                    PageInfoView(
                        infoPages: [
                            .selectionExplanation1,
                            .selectionExplanation2,
                            .selectionExplanation3,
                            .selectionExplanation4,
                        ],
                        image: .ReinaEmotes.training,
                    )
                }
        }
        .toolbar {
            ToolbarViews(
                kanaSelectionType: $kanaSelectionType,
                showRomaji: $showRomaji,
                showInfo: $showInfo,
                selectedBase: $selectedBase,
                selectedDiacritic: $selectedDiacritic,
                selectedCombinatory: $selectedCombinatory,
                selectedCombinatoryDiacritic: $selectedCombinatoryDiacritic,
                selectedExtendedKatakana: $selectedExtendedKatakana,
            )
        }
        .navigationTitle(.kanaTraining)
        .navigationBarTitleDisplayMode(.large)
    }

    var textForSelectedKanas: String {
        let baseCount = "\(selectedBase.kanaCount)/\(base.kanaCount)"
        let diacriticCount = "\(selectedDiacritic.kanaCount)/\(diacritic.kanaCount)"
        let combinatoryCount = "\(selectedCombinatory.kanaCount)/\(combinatory.kanaCount)"
        let combinatoryDiacriticCount = "\(selectedCombinatoryDiacritic.kanaCount)/\(combinatoryDiacritic.kanaCount)"
        let extendedKatakanaCount = "\(selectedExtendedKatakana.kanaCount)/\(extendedKatakana.kanaCount)"

        var selectedCountText: [String] = []

        if !selectedBase.isEmpty { selectedCountText.append(baseCount) }
        if !selectedDiacritic.isEmpty { selectedCountText.append(diacriticCount) }
        if !selectedCombinatory.isEmpty { selectedCountText.append(combinatoryCount) }
        if !selectedCombinatoryDiacritic.isEmpty { selectedCountText.append(combinatoryDiacriticCount) }
        if !selectedExtendedKatakana.isEmpty { selectedCountText.append(extendedKatakanaCount) }
        return selectedCountText.joined(separator: "  |  ")
    }

    var selectedKanasForExercise: [Kana] {
        let unionedSet = selectedBase
            .union(selectedDiacritic)
            .union(selectedCombinatory)
            .union(selectedCombinatoryDiacritic)

        let unionedKanas = unionedSet.map(\.kanas).joined().compactMap(\.self)

        let katakanaOnlyKanas = selectedExtendedKatakana.map(\.kanas).joined().compactMap(\.self)

        let fullHiraganaSet: [Kana] = unionedKanas.map { .hiragana(value: $0) }
        let fullKatakanaSet: [Kana] = unionedKanas.map { .katakana(value: $0) } + katakanaOnlyKanas
            .map { .katakana(value: $0) }

        return switch kanaSelectionType {
        case .hiragana: fullHiraganaSet
        case .both: fullHiraganaSet + fullKatakanaSet
        case .katakana: fullKatakanaSet
        }
    }

    func onExerciceSelectionTapped() {
        coordinator.push(.exerciseSelection(selectedKanasForExercise))
    }
}

struct ToolbarViews: View {
    @Binding var kanaSelectionType: KanaSelectionType
    @State var showsFastSelect: Bool = false

    @Binding var showRomaji: Bool
    @Binding var showInfo: Bool

    @Binding var selectedBase: Set<KanaLine>
    @Binding var selectedDiacritic: Set<KanaLine>
    @Binding var selectedCombinatory: Set<KanaLine>
    @Binding var selectedCombinatoryDiacritic: Set<KanaLine>
    @Binding var selectedExtendedKatakana: Set<KanaLine>

    var body: some View {
        Picker(.trainingMode, selection: $kanaSelectionType) {
            ForEach(KanaSelectionType.allCases, id: \.self) { Text($0.localisedDescription) }
        }
        .pickerStyle(.menu)
        Toggle(.romaji, isOn: $showRomaji)
        Button(action: { showsFastSelect.toggle() }) { Image(systemName: "text.line.first.and.arrowtriangle.forward") }
            .popover(isPresented: $showsFastSelect) {
                FastSelectPopoverView(
                    selectedBase: $selectedBase,
                    selectedDiacritic: $selectedDiacritic,
                    selectedCombinatory: $selectedCombinatory,
                    selectedCombinatoryDiacritic: $selectedCombinatoryDiacritic,
                    selectedExtendedKatakana: $selectedExtendedKatakana,
                )
            }
        Button("", systemImage: "info.circle", action: { showInfo.toggle() })
    }
}

struct TrainingButtonView: View {
    let title: String
    let popoverHelpText: String

    let onButtonTapped: () -> Void
    @Binding var isPopoverPresented: Bool

    var body: some View {
        Button(title) { onButtonTapped() }.buttonStyle(.borderedProminent)
            .popover(isPresented: $isPopoverPresented, arrowEdge: .bottom) {
                VStack(alignment: .leading) {
                    Text(title)
                        .typography(.headline)
                    Text(popoverHelpText)
                }
                .fixedSize(horizontal: false, vertical: true)
                .presentationCompactAdaptation(.popover)
                .padding()
                .padding(.vertical, 20)
            }
    }
}

extension Color {
    static let bgColor: Color = {
        #if os(iOS)
            Color(uiColor: .systemBackground)
        #elseif os(macOS)
            Color(NSColor.controlBackgroundColor)
        #endif
    }()
}

enum CatagoryColor {
    static let base: Color = .green
    static let diacritic: Color = .yellow
    static let combinatory: Color = .orange
    static let combinarotyDiacritic: Color = .pink
    static let extendedKatakana: Color = .purple
}
