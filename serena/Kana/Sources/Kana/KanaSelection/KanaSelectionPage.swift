import SwiftUI
import Helpers
import Navigation

public struct KanaSelectionPage: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    
    @State var selectedBase: Set<KanaLine> = []
    @State var selectedDiacritic: Set<KanaLine> = []
    @State var selectedCombinatory: Set<KanaLine> = []
    @State var selectedCombinatoryDiacritic: Set<KanaLine> = []
    @State var selectedNew: Set<KanaLine> = []
    
    @State var displayAsKana: Bool = true
    
    @State var kanaType: KanaType = .hiragana
    
    @State var showLevelUpPopover: Bool = false
    @State var showAllInARowPopover: Bool = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack(path: coordinator.binding(for: \.path)) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(.selectTheRowsYouWantToTrainOnAndPickAModeBelow)
                        .font(.subheadline)
                        .padding()
                    
                    Picker(.trainingMode, selection: $kanaType) {
                        ForEach (KanaType.allCases, id: \.self) {
                            Text("\($0.rawValue) 【\($0.letter)】")
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    KanaLineGroupView(
                        title: "【\("ka".format(kanaType))】\(localized(.base)) \(kanaType.rawValue)",
                        lines: base, selectedLines: $selectedBase,
                    )
                    KanaLineGroupView(
                        title: "【\("ga".format(kanaType))】\(localized(.diacritics)) (dakuten/handakuten)",
                        lines: diacritic, selectedLines: $selectedDiacritic,
                    )
                    KanaLineGroupView(title: "【\("sha".format(kanaType))】\(localized(.combinatory))",
                        lines: combinatory, selectedLines: $selectedCombinatory,
                    )
                    KanaLineGroupView(
                        title: "【\("ja".format(kanaType))】\(localized(.combinatoryDiacritics))",
                        lines: combinatoryDiacritic, selectedLines: $selectedCombinatoryDiacritic,
                    )
                    if case .katakana = kanaType {
                        KanaLineGroupView(title: "【新】\(localized(.newCases))", lines: new, selectedLines: $selectedNew)
                    }
                    Spacer()
                        .frame(height: 80)
                }
            }
            .overlay(alignment: .bottom) {
                BottomViews(
                    kanaType: $kanaType,
                    showLevelUpPopover: $showLevelUpPopover,
                    showAllInARowPopover: $showAllInARowPopover,
                    textForSelectedKanas: textForSelectedKanas,
                    onLevelUpsTapped: onLevelUpsTapped,
                    onAllInARowTapped: onAllInARowTapped,
                    areTrainingModeButtonDisabled: !hasAnySelected
                )
            }
            .toolbar {
                ToolbarViews(
                    displayAsKana: $displayAsKana,
                    showLevelUpPopover: $showLevelUpPopover,
                    kanaType: kanaType,
                    selectedBase: $selectedBase,
                    selectedDiacritic: $selectedDiacritic,
                    selectedCombinatory: $selectedCombinatory,
                    selectedCombinatoryDiacritic: $selectedCombinatoryDiacritic,
                    selectedNew: $selectedNew
                )
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case let .levelUps(kanas):
                    LevelUpsPage(kanas: kanas, kanaType: kanaType)
                case let .allInARow(kanas):
                    AllInARowPage(kanas: kanas, kanaType: kanaType)
                }
            }
            .onChange(of: kanaType, { _,_ in selectedNew.removeAll() })
            .onChange(of: showLevelUpPopover) { oldValue, newValue in
                if oldValue && !newValue {
                    showAllInARowPopover = true
                }
            }
            .navigationTitle(.kanaTraining)
            .environment(\.kanaDisplayType, kanaDisplayType)
        }
        .animation(.easeInOut, value: kanaType)
    }
    
    var kanaDisplayType: KanaDisplayType {
        switch (displayAsKana, kanaType) {
        case (true , .hiragana): .asHiragana
        case (true , .katakana): .asKatakana
        case (false , .hiragana): .asLowercasedRomaji
        case (false , .katakana): . asUppercasedRomaji
        }
    }
    
    var textForSelectedKanas: String {
        let baseCount: String = "ka".format(kanaType) + "\(selectedBase.kanaCount)/\(base.kanaCount) "
        let diacriticCount = "ga".format(kanaType) + "\(selectedDiacritic.kanaCount)/\(diacritic.kanaCount) "
        let combinatoryCount = "sha".format(kanaType) + "\(selectedCombinatory.kanaCount)/\(combinatory.kanaCount) "
        let combinatoryDiacriticCount = "ja".format(kanaType) + "\(selectedCombinatoryDiacritic.kanaCount)/\(combinatoryDiacritic.kanaCount) "
        let newCount = "新\(selectedNew.kanaCount)/\(new.kanaCount)"
        
        var selectedCountText: String = ""
        
        if !selectedBase.isEmpty { selectedCountText.append(baseCount) }
        if !selectedDiacritic.isEmpty { selectedCountText.append(diacriticCount)}
        if !selectedCombinatory.isEmpty { selectedCountText.append(combinatoryCount)}
        if !selectedCombinatoryDiacritic.isEmpty { selectedCountText.append(combinatoryDiacriticCount)}
        if !selectedNew.isEmpty { selectedCountText.append(newCount)}
        return selectedCountText
    }
    
    var mergedKanas: [String] {
        let unionedSet = selectedBase
            .union(selectedDiacritic)
            .union(selectedCombinatory)
            .union(selectedCombinatoryDiacritic)
            .union(selectedNew)
        
        return unionedSet.map(\.kanas).joined().compactMap {$0}
    }
    
    func onLevelUpsTapped() {
        coordinator.push(.levelUps(mergedKanas))
    }
    
    func onAllInARowTapped() {
        coordinator.push(.allInARow(mergedKanas))
    }
    
    var hasAnySelected: Bool {
        !selectedBase.isEmpty
        || !selectedDiacritic.isEmpty
        || !selectedCombinatory.isEmpty
        || !selectedCombinatoryDiacritic.isEmpty
        || !selectedNew.isEmpty
    }
}

struct ToolbarViews: View {
    @State var showsFastSelect: Bool = false
    
    @Binding var displayAsKana: Bool
    @Binding var showLevelUpPopover: Bool
    let kanaType: KanaType
    
    @Binding var selectedBase: Set<KanaLine>
    @Binding var selectedDiacritic: Set<KanaLine>
    @Binding var selectedCombinatory: Set<KanaLine>
    @Binding var selectedCombinatoryDiacritic: Set<KanaLine>
    @Binding var selectedNew: Set<KanaLine>
    
    var body: some View {
        let swapDisplayModeText: String = if displayAsKana {
            "\(kanaType.letter)↔\(kanaType.romajiLetter)"
        } else {
            "\(kanaType.romajiLetter)↔\(kanaType.letter)"
        }
        
        Button(swapDisplayModeText) { withAnimation { displayAsKana.toggle()} }
        Button(localized(.fastSelect)) { showsFastSelect.toggle() }
            .popover (isPresented: $showsFastSelect) {
                FastSelectPopoverView(
                    kanaType: kanaType,
                    selectedBase: $selectedBase,
                    selectedDiacritic: $selectedDiacritic,
                    selectedCombinatory: $selectedCombinatory,
                    selectedCombinatoryDiacritic: $selectedCombinatoryDiacritic,
                    selectedNew: $selectedNew
                )
            }
        Button(
            action: { showLevelUpPopover = true },
            label: { Image(systemName: "questionmark.circle")}
        )
    }
}

struct BottomViews: View {
    @Binding var kanaType: KanaType
    
    @Binding var showLevelUpPopover: Bool
    @Binding var showAllInARowPopover: Bool
    
    let textForSelectedKanas: String
    
    let onLevelUpsTapped: () -> Void
    let onAllInARowTapped: () -> Void
    let areTrainingModeButtonDisabled: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            BottomGradient()
            VStack(spacing: 8) {
                ZStack {
                    HStack(spacing: 20) {
                        TrainingButtonView(
                            title: localized(.levelUps),
                            popoverHelpText: localized(.testYourKnowledgeOn10RandomKanasChosenFromTheSelectionWithIncreasingDifficulty),
                            onButtonTapped: onLevelUpsTapped,
                            isPopoverPresented: $showLevelUpPopover
                        )
                        TrainingButtonView(
                            title: localized(.allInARow),
                            popoverHelpText: localized(.tryToGetAllSelectedKanasRightInARow),
                            onButtonTapped: onAllInARowTapped,
                            isPopoverPresented: $showAllInARowPopover
                        )
                    }
                    .disabled(areTrainingModeButtonDisabled)

                    HStack {
                        Text(.mode)
                        Spacer()
                        Picker(.trainingMode, selection: $kanaType) {
                            ForEach (KanaType.allCases, id: \.self) { Text($0.letter) }
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
