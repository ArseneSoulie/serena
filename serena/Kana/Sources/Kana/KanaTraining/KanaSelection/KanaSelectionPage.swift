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

    @State var kanaSelectionType: KanaSelectionType = .hiragana

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Image(.ReinaEmotes.training)
                        .resizable()
                        .frame(width: 64, height: 64)
                    Text(localized("Select the rows you want to train on and pick a mode below."))
                }
                .padding()

                Picker(localized("Training mode"), selection: $kanaSelectionType) {
                    ForEach(KanaSelectionType.allCases, id: \.self) {
                        Text($0.localisedDescription)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                KanaLineGroupView(
                    title: localized("Base"),
                    lines: base,
                    selectedLines: $selectedBase,
                    showRomaji: showRomaji,
                    kanaSelectionType: kanaSelectionType,
                    tint: CatagoryColor.base,
                )
                KanaLineGroupView(
                    title: localized("Diacritics"),
                    lines: diacritic,
                    selectedLines: $selectedDiacritic,
                    showRomaji: showRomaji,
                    kanaSelectionType: kanaSelectionType,
                    tint: CatagoryColor.diacritic,
                )
                KanaLineGroupView(
                    title: localized("Combinatory"),
                    lines: combinatory,
                    selectedLines: $selectedCombinatory,
                    showRomaji: showRomaji,
                    kanaSelectionType: kanaSelectionType,
                    tint: CatagoryColor.combinatory,
                )
                KanaLineGroupView(
                    title: localized("Combinatory diacritics"),
                    lines: combinatoryDiacritic,
                    selectedLines: $selectedCombinatoryDiacritic,
                    showRomaji: showRomaji,
                    kanaSelectionType: kanaSelectionType,
                    tint: CatagoryColor.combinarotyDiacritic,
                )
                KanaLineGroupView(
                    title: localized("Extended katakana"),
                    lines: extendedKatakana,
                    selectedLines: $selectedExtendedKatakana,
                    showRomaji: showRomaji,
                    kanaSelectionType: .katakana,
                    tint: CatagoryColor.extendedKatakana,
                )
                .disabled(kanaSelectionType == .hiragana)
                .opacity(kanaSelectionType == .hiragana ? 0.3 : 1)
                Spacer()
                    .frame(height: 160)
            }
        }
        .animation(.default, value: showRomaji)
        .animation(.default, value: kanaSelectionType)
        .overlay(alignment: .bottom) {
            BottomViews(
                kanaSelectionType: $kanaSelectionType,
                textForSelectedKanas: textForSelectedKanas,
                totalSelectedKanas: selectedKanasForExercise.count,
                onExerciceSelectionTapped: onExerciceSelectionTapped,
            )
        }
        .toolbar {
            ToolbarViews(
                showRomaji: $showRomaji,
                selectedBase: $selectedBase,
                selectedDiacritic: $selectedDiacritic,
                selectedCombinatory: $selectedCombinatory,
                selectedCombinatoryDiacritic: $selectedCombinatoryDiacritic,
                selectedExtendedKatakana: $selectedExtendedKatakana,
            )
        }
        .navigationTitle(localized("Kana training"))
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
    @State var showsFastSelect: Bool = false

    @Binding var showRomaji: Bool

    @Binding var selectedBase: Set<KanaLine>
    @Binding var selectedDiacritic: Set<KanaLine>
    @Binding var selectedCombinatory: Set<KanaLine>
    @Binding var selectedCombinatoryDiacritic: Set<KanaLine>
    @Binding var selectedExtendedKatakana: Set<KanaLine>

    var body: some View {
        Toggle(localized("Show romaji"), isOn: $showRomaji)
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
    }
}

struct BottomViews: View {
    @Binding var kanaSelectionType: KanaSelectionType

    let textForSelectedKanas: String
    let totalSelectedKanas: Int
    let onExerciceSelectionTapped: () -> Void

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Picker(localized("Training mode"), selection: $kanaSelectionType) {
                    ForEach(KanaSelectionType.allCases, id: \.self) { Text($0.localisedDescription) }
                }
                .pickerStyle(.segmented)
                Button(localized("Let's go ! %lld", totalSelectedKanas), action: onExerciceSelectionTapped)
                    .buttonStyle(.borderedProminent)
                    .disabled(totalSelectedKanas == 0)
            }
            .padding(.horizontal)
            Text(textForSelectedKanas)
                .typography(.footnote)
        }
        .padding(4)
        .padding(.top, 16)
        .background {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Gradient(stops: [
                        .init(color: Color.bgColor.opacity(0), location: 0),
                        .init(color: Color.bgColor.opacity(0.2), location: 0.05),
                        .init(color: Color.bgColor, location: 0.2),
                    ]))
                Color.bgColor.ignoresSafeArea(.all)
            }
        }
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
