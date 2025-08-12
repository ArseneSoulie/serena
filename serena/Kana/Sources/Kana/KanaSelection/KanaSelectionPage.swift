import SwiftUI
import Navigation
import FoundationModels

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
        NavigationStack(path: coordinator.binding(for: \.path)) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(localized("Select the rows you want to train on and pick a mode below."))
                        .font(.subheadline)
                        .padding()
                    
                    Picker(localized("Training mode"), selection: $kanaSelectionType) {
                        ForEach (KanaSelectionType.allCases, id: \.self) {
                            Text(localized($0.rawValue))
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
                    )
                    KanaLineGroupView(
                        title: localized("Diacritics"),
                        lines: diacritic,
                        selectedLines: $selectedDiacritic,
                        showRomaji: showRomaji,
                        kanaSelectionType: kanaSelectionType,
                    )
                    KanaLineGroupView(
                        title: localized("Combinatory"),
                        lines: combinatory,
                        selectedLines: $selectedCombinatory,
                                      showRomaji: showRomaji,
                                      kanaSelectionType: kanaSelectionType,
                    )
                    KanaLineGroupView(
                        title: localized("Combinatory diacritics"),
                        lines: combinatoryDiacritic,
                        selectedLines: $selectedCombinatoryDiacritic,
                        showRomaji: showRomaji,
                        kanaSelectionType: kanaSelectionType,
                    )
                    let willPartiallyRepresentSelection = (kanaSelectionType == .hiragana || kanaSelectionType == .both) && !selectedExtendedKatakana.isEmpty
                    if willPartiallyRepresentSelection {
                        Text("The extended group will only show characters in the katakana form")
                            .padding()
                    }
                    KanaLineGroupView(
                        title: localized("Extended katakana"),
                        lines: extendedKatakana,
                        selectedLines: $selectedExtendedKatakana,
                        showRomaji: showRomaji,
                        kanaSelectionType: kanaSelectionType,
                    )
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
                    selectedExtendedKatakana: $selectedExtendedKatakana
                )
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case let .levelUps(kanas):
                    LevelUpsPage(kanas: kanas)
                case let .allInARow(kanas):
                    AllInARowPage(kanas: kanas)
                case let .exerciseSelection(kanas):
                    ExerciseSelectionPage(kanaPool: kanas)
                }
            }
            .navigationTitle(localized("Kana training"))
        }
    }

    
    var textForSelectedKanas: String {
        let baseCount: String = "\(selectedBase.kanaCount)/\(base.kanaCount) "
        let diacriticCount = "\(selectedDiacritic.kanaCount)/\(diacritic.kanaCount) "
        let combinatoryCount = "\(selectedCombinatory.kanaCount)/\(combinatory.kanaCount) "
        let combinatoryDiacriticCount = "\(selectedCombinatoryDiacritic.kanaCount)/\(combinatoryDiacritic.kanaCount) "
        let extendedKatakanaCount = "\(selectedExtendedKatakana.kanaCount)/\(extendedKatakana.kanaCount)"
        
        var selectedCountText: String = ""
        
        if !selectedBase.isEmpty { selectedCountText.append(baseCount) }
        if !selectedDiacritic.isEmpty { selectedCountText.append(diacriticCount)}
        if !selectedCombinatory.isEmpty { selectedCountText.append(combinatoryCount)}
        if !selectedCombinatoryDiacritic.isEmpty { selectedCountText.append(combinatoryDiacriticCount)}
        if !selectedExtendedKatakana.isEmpty { selectedCountText.append(extendedKatakanaCount)}
        return selectedCountText
    }
    
    var selectedKanasForExercise: [Kana] {
        let unionedSet = selectedBase
            .union(selectedDiacritic)
            .union(selectedCombinatory)
            .union(selectedCombinatoryDiacritic)
        
        let unionedKanas = unionedSet.map(\.kanas).joined().compactMap {$0}
        
        let katakanaOnlyKanas = selectedExtendedKatakana.map(\.kanas).joined().compactMap {$0}
        
        let fullHiraganaSet: [Kana] = unionedKanas.map { .hiragana(value: $0) }
        let fullKatakanaSet: [Kana] = unionedKanas.map { .katakana(value: $0) } + katakanaOnlyKanas.map { .katakana(value: $0) }
        
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
        Toggle("Show romaji", isOn: $showRomaji)
        Button(localized("Fast select")) { showsFastSelect.toggle() }
            .popover (isPresented: $showsFastSelect) {
                FastSelectPopoverView(
                    selectedBase: $selectedBase,
                    selectedDiacritic: $selectedDiacritic,
                    selectedCombinatory: $selectedCombinatory,
                    selectedCombinatoryDiacritic: $selectedCombinatoryDiacritic,
                    selectedExtendedKatakana: $selectedExtendedKatakana
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
        ZStack(alignment: .bottom) {
            BottomGradient()
            VStack(spacing: 8) {
                ZStack {
                    Button("Let's go \(totalSelectedKanas)", action: onExerciceSelectionTapped)
                        .buttonStyle(.borderedProminent)
                        .disabled(totalSelectedKanas == 0)

                    HStack {
                        Text(localized("Mode"))
                        Spacer()
                        Picker(localized("Training mode"), selection: $kanaSelectionType) {
                            ForEach (KanaSelectionType.allCases, id: \.self) { Text($0.symbol) }
                        }
                        .pickerStyle(.segmented)
                        .fixedSize()
                    }
                }
            .padding(.horizontal)
                Text(textForSelectedKanas)
                    .font(.footnote)
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
                        .font(.headline)
                    Text(popoverHelpText)
                }
                .fixedSize(horizontal: false, vertical: true)
                .presentationCompactAdaptation(.popover)
                .padding()
                .padding(.vertical, 20)
            }
    }
}


struct BottomGradient: View {
    var body: some View {
        Rectangle()
            .fill( Gradient(stops: [
                .init(color: Color.bgColor.opacity(0), location: 0.8),
                .init(color: Color.bgColor.opacity(0.2), location: 0.85),
                .init(color: Color.bgColor, location: 0.9),
            ]))
            .ignoresSafeArea(edges: .bottom)
            .allowsHitTesting(false)
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
