//
//  KanaTestingView.swift
//  SerenaApp
//
//  Created by A S on 01/08/2025.
//

struct KanaLine: Identifiable, Hashable {
    let name: String
    let kanas: [KanaText?]
    
    var id: String { name }
}

typealias KanaText = String

extension KanaText? {
    var kanaId: String {
        if let self {
            self
        } else {
            UUID().uuidString
        }
    }
}

let base: [KanaLine] = [
    .init(name:"-" , kanas:["a","i","u","e","o"]),
    .init(name:"k-" , kanas:["ka","ki","ku","ke","ko"]),
    .init(name:"s-" , kanas:["sa","shi","su","se","so"]),
    .init(name:"t-" , kanas:["ta","chi","tsu","te","to"]),
    .init(name:"n-" , kanas:["na","ni","nu","ne","no"]),
    .init(name:"h-" , kanas:["ha","hi","fu","he","ho"]),
    .init(name:"m-" , kanas:["ma","mi","mu","me","mo"]),
    .init(name:"y-" , kanas:["ya",nil,"yu",nil,"yo"]),
    .init(name:"r-" , kanas:["ra","ri","ru","re","ro"]),
    .init(name:"w-" , kanas:["wa",nil,nil,nil,"wo"]),
    .init(name:"n" , kanas:["n"]),
]

let diacritic: [KanaLine] = [
    .init(name:"g-" , kanas:["ga","gi","gu","ge","go"]),
    .init(name:"z-" , kanas:["za","ji","zu","ze","zo"]),
    .init(name:"d-" , kanas:["da","di","du","de","do"]),
    .init(name:"b-" , kanas:["ba","bi","bu","be","bo"]),
    .init(name:"p-" , kanas:["pa","pi","pu","pe","po"]),
]

let combinatory: [KanaLine] = [
    .init(name:"ky-" , kanas:["kya","kyu","kyo"]),
    .init(name:"sh-" , kanas:["sha","shu","sho"]),
    .init(name:"ch-" , kanas:["cha","chu","cho"]),
    .init(name:"ny-" , kanas:["nya","nyu","nyo"]),
    .init(name:"hy-" , kanas:["hya","hyu","hyo"]),
    .init(name:"my-" , kanas:["mya","myu","myo"]),
    .init(name:"ry-" , kanas:["rya","ryu","ryo"]),
]

let combinatoryDiacritic: [KanaLine] = [
    .init(name:"gy-" , kanas:["gya","gyu","gyo"]),
    .init(name:"j-" , kanas:["ja","ju","jo"]),
    .init(name:"dy-" , kanas:["dya","dyu","dyo"]),
    .init(name:"by-" , kanas:["bya","byu","byo"]),
    .init(name:"py-" , kanas:["pya","pyu","pyo"]),
]

let new: [KanaLine] = [
    .init(name:"sh-" , kanas:["she"]),
    .init(name:"j-" , kanas:["je"]),
    .init(name:"ch-" , kanas:["che"]),
    .init(name:"ts-" , kanas:["tsa","tsi","tse","tso"]),
    .init(name:"f-" , kanas:["fa","fi","fe","fo"]),
    .init(name:"w-" , kanas:["wi","we","uxo"]),
    .init(name:"v-" , kanas:["va","vi","vu","ve","vo"]),
    .init(name:"∗" , kanas:["thi","dhi","twu","dwu"]),
]

import SwiftUI

struct Line: View {
    let kanaLine: KanaLine
    @Binding var isOn: Bool
    let spacing = 4.0
    
    @Environment(\.displayAsKana) var displayAsKana
    @Environment(\.trainingMode) var trainingMode
    
    var body: some View {
        GridRow {
            Button(action: { withAnimation {isOn.toggle()}}  ) {
                HStack {
                    Text(kanaLine.id)
                        .tint(.primary)
                }
                .padding(8)
            }
            .gridColumnAlignment(.trailing)
            Button(action: { withAnimation {isOn.toggle()}} ) {
                HStack(spacing: spacing) {
                    ForEach(kanaLine.kanas, id: \.kanaId) { kana in
                        let displayedText = if !displayAsKana {
                            kana ?? "a"
                        } else {
                            switch trainingMode {
                            case .hiragana:
                                kana?.romajiToKatakana.asHiragana ?? "あ"
                            case .katakana:
                                kana?.romajiToKatakana ?? "ア"
                            }
                            
                        }
                        Text(displayedText)
                            .font(.title2)
                            .padding(.all, 6)
                            .frame(maxWidth: .infinity)
                            .background { Color(white: 0.97) }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .opacity(kana == nil ? 0 : 1)
                    }
                }
                .padding(.all, spacing)
                .foregroundStyle (isOn ? Color(white: 0.2) : Color(white: 0.4))
                .background { isOn ? .mint : Color(white: 0.92) }
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.vertical, 2)
        }
    }
}

extension Set<KanaLine> {
    subscript(containsLine kanaLine: KanaLine) -> Bool {
        get { self.contains(kanaLine) }
        set {
            if newValue {
                self.insert(kanaLine)
            } else {
                self.remove(kanaLine)
            }
        }
    }
}

extension Set<KanaLine> {
    var kanaCount: Int {
        self.reduce(0) { partialResult, line in
            partialResult + line.kanas.count(where: { $0 != nil} )
        }
    }
}

extension Array<KanaLine> {
    var kanaCount: Int {
        self.reduce(0) { partialResult, line in
            partialResult + line.kanas.count(where: { $0 != nil} )
        }
    }
}

struct LineGroup: View {
    let title: String
    let lines: [KanaLine]
    @Binding var selectedRows: Set<KanaLine>

    @State var isExpanded: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            DisclosureGroup(isExpanded: $isExpanded) {
                Grid(alignment: .leading) {
                    ForEach(lines) { kanaLine in
                        Line(kanaLine: kanaLine, isOn: $selectedRows[containsLine: kanaLine])
                    }
                }.padding(.vertical, 8)
            } label: {
                HStack {
                    Button("", systemImage: hasSelectedAll ? "checkmark.circle.fill" : "checkmark.circle") { toggleSelectBase()}
                        .tint(hasSelectedAll ? .mint : .gray)
                    Text("\(title) \(selectedRows.kanaCount)/\(lines.kanaCount)").font(.subheadline)
                }
            }
            
            Divider()
        }.padding(.horizontal)
    }
    
    var hasSelectedAll: Bool {
        selectedRows.count == lines.count
    }
    
    func toggleSelectBase() {
        withAnimation {
            if hasSelectedAll { selectedRows.removeAll() }
            else { selectedRows.formUnion(lines) }
        }
    }
}

extension EnvironmentValues {
    @Entry var displayAsKana: Bool = true
    @Entry var trainingMode: KanaTrainingMode = .katakana
}

import SwiftUI

struct BottomBlurModifier: ViewModifier {
    @Binding var height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .visualEffect { [height] initial, geo in
                let globalFrame = geo.frame(in: .global)
                
                return initial
                    .layerEffect(
                        ShaderLibrary.bundle(.module).pixellate(
                            .float(8),
                            .float(globalFrame.minY),
                            .float(height)
                        ),
                        maxSampleOffset: .zero
                    )
            }
    }
}

extension View {
    func blurBottom(height: Binding<CGFloat>) -> some View {
        self.modifier(BottomBlurModifier(height: height))
    }
}

enum Destination: Hashable {
    case levelUps([String])
    case allInARow([String])
}

enum KanaTrainingMode: String, CaseIterable, Hashable {
    case hiragana
    case katakana
}

struct AllInARowTrainingView: View {
    let kanas: [String]
    var body: some View {
        Text("Hello, world!")
    }
}


struct LevelUpsTrainingView: View {
    let kanas: [String]
    var body: some View {
        Text("Hello, world!")
    }
}

struct Train: View {
    @State var selectedBase: Set<KanaLine> = []
    @State var selectedDiacritic: Set<KanaLine> = []
    @State var selectedCombinatory: Set<KanaLine> = []
    @State var selectedCombinatoryDiacritic: Set<KanaLine> = []
    @State var selectedNew: Set<KanaLine> = []
    
    @State var showsFastSelect: Bool = false
    @State var displayAsKana: Bool = true
    @State var trainingMode: KanaTrainingMode = .katakana
    
    @State private var destinations: [Destination] = []
    
    init() {
        setupMetal()
    }
    
    @State var height = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack(path: $destinations) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Select the rows you want to train on and pick a mode below.")
                        .font(.subheadline)
                        .padding()
                    Picker(selection: $trainingMode) {
                        ForEach (KanaTrainingMode.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    } label: {
                        Text("Training mode")
                    }.pickerStyle(.segmented).padding()
                        
                    
                    LineGroup(title: "Base \(trainingMode.rawValue)", lines: base, selectedRows: $selectedBase, isExpanded: true)
                        .tint(selectedBase.isEmpty ? .secondary : .mint)
                    LineGroup(title: "Diacritics (dakuten/handakuten)", lines: diacritic, selectedRows: $selectedDiacritic, isExpanded: false)
                        .tint(selectedDiacritic.isEmpty ? .secondary : .mint)
                    LineGroup(title: "Combinatory", lines: combinatory, selectedRows: $selectedCombinatory, isExpanded: false)
                        .tint(selectedCombinatory.isEmpty ? .secondary : .mint)
                    LineGroup(title: "Combinatory diacritics", lines: combinatoryDiacritic, selectedRows: $selectedCombinatoryDiacritic, isExpanded: false)
                        .tint(selectedCombinatoryDiacritic.isEmpty ? .secondary : .mint)
                    if case .katakana = trainingMode {
                        LineGroup(title: "New cases", lines: new, selectedRows: $selectedNew, isExpanded: false)
                            .tint(selectedNew.isEmpty ? .secondary : .mint)
                    }
                    Spacer()
                        .frame(height: 80)
                }
            }
            .overlay {
                Rectangle()
                    .fill( Gradient(stops: [
                        .init(color: Color(.systemBackground).opacity(0), location: 0.8),
                        .init(color: Color(.systemBackground).opacity(0.2), location: 0.88),
                        .init(color: Color(.systemBackground), location: 0.93),
                    ]))
                    .ignoresSafeArea(edges: .bottom)
                    .allowsHitTesting(false)
                
            }
            .environment(\.displayAsKana, displayAsKana)
            .environment(\.trainingMode, trainingMode)
            .overlay(alignment: .bottom) {
                VStack {
                    let selectedCountText = switch trainingMode {
                    case .hiragana:
                        """
                        か\(selectedBase.kanaCount)/\(base.kanaCount)   \
                        が\(selectedDiacritic.kanaCount)/\(diacritic.kanaCount)   \
                        しゃ\(selectedCombinatory.kanaCount)/\(combinatory.kanaCount)   \
                        じゃ\(selectedCombinatoryDiacritic.kanaCount)/\(combinatoryDiacritic.kanaCount)
                        """
                    case .katakana:
                        """
                        カ\(selectedBase.kanaCount)/\(base.kanaCount)   \
                        ガ\(selectedDiacritic.kanaCount)/\(diacritic.kanaCount)   \
                        シャ\(selectedCombinatory.kanaCount)/\(combinatory.kanaCount)   \
                        ジャ\(selectedCombinatoryDiacritic.kanaCount)/\(combinatoryDiacritic.kanaCount)   \
                        新\(selectedNew.kanaCount)/\(new.kanaCount)
                        """
                    }
                    
                    KanaTrainingButtonView(onLevelUpsTapped: onLevelUpsTapped, onAllInARowTapped: onAllInARowTapped)
                    Text(selectedCountText)
                        .font(.footnote)
                }
            }
            .onChange(of: trainingMode, { _,_ in
                selectedNew.removeAll()
            })

            .navigationTitle("Kana training")
            .toolbar {
                let switchToRomajiText = switch trainingMode {
                case .hiragana:
                    displayAsKana ? "あ↔A" : "A↔あ"
                case .katakana:
                    displayAsKana ? "ア↔A" : "A↔ア"
                }
                Button(switchToRomajiText) { withAnimation { displayAsKana.toggle()} }
                Button("Fast select") { showsFastSelect.toggle() }
                    .popover (isPresented: $showsFastSelect) {
                        VStack(alignment: .leading) {
                            KanaToolbarButton(
                                title: "Everything",
                                isOn: hasSelectedEverything,
                                onToggle: toggleEverythingSelection
                            )
                            KanaToolbarButton(
                                title: "Base \(trainingMode.rawValue)",
                                isOn: hasSelectedAllBase,
                                onToggle: toggleSelectBase
                            )
                            KanaToolbarButton(
                                title: "Diacritics",
                                isOn: hasSelectedAllDiacritic,
                                onToggle: toggleSelectDiacritic
                            )
                            KanaToolbarButton(
                                title: "Combinatory",
                                isOn: hasSelectedAllCombinatory,
                                onToggle: toggleSelectCombinatory
                            )
                            KanaToolbarButton(
                                title: "Combinatory diacritics",
                                isOn: hasSelectedAllCombinatoryDiacritic,
                                onToggle: toggleSelectCombinatoryDiacritic
                            )
                            if case .katakana = trainingMode {
                                KanaToolbarButton(
                                    title: "New cases",
                                    isOn: hasSelectedAllNew,
                                    onToggle: toggleSelectNew
                                )
                            }
                        }
                        .padding()
                        .presentationCompactAdaptation(.popover)
                    }
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case let .levelUps(kanas):
                    LevelUpsTrainingView(kanas: kanas)
                case let .allInARow(kanas):
                    AllInARowTrainingView(kanas: kanas)
                }
            }
            
        }
        .animation(.easeInOut, value: trainingMode)
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
        let tenRandomFirstKanas = Array(mergedKanas.shuffled().prefix(10))
        destinations.append(.levelUps(tenRandomFirstKanas))
    }
    
    func onAllInARowTapped() {
        destinations.append(.allInARow(mergedKanas))
    }
    
    var hasSelectedEverything: Bool {
        let newIfNeeded = trainingMode == .katakana ? hasSelectedAllNew : true
        
        return hasSelectedAllBase &&
        hasSelectedAllDiacritic &&
        hasSelectedAllCombinatory &&
        hasSelectedAllCombinatoryDiacritic &&
        newIfNeeded
    }
    
    func toggleEverythingSelection() {
        withAnimation {
            if hasSelectedEverything {
                selectedBase.removeAll()
                selectedDiacritic.removeAll()
                selectedCombinatory.removeAll()
                selectedCombinatoryDiacritic.removeAll()
                if trainingMode == .katakana {
                    selectedNew.removeAll()
                }
            } else {
                selectedBase.formUnion(base)
                selectedDiacritic.formUnion(diacritic)
                selectedCombinatory.formUnion(combinatory)
                selectedCombinatoryDiacritic.formUnion(combinatoryDiacritic)
                if trainingMode == .katakana {
                    selectedNew.formUnion(new)
                }
            }
        }
    }
    
    var hasSelectedAllBase: Bool { selectedBase.count == base.count }
    var hasSelectedAllDiacritic: Bool {selectedDiacritic.count == diacritic.count}
    var hasSelectedAllCombinatory: Bool {selectedCombinatory.count == combinatory.count}
    var hasSelectedAllCombinatoryDiacritic: Bool {selectedCombinatoryDiacritic.count == combinatoryDiacritic.count}
    var hasSelectedAllNew: Bool {selectedNew.count == new.count}
    
    func toggleSelectBase() {
        withAnimation {
            if hasSelectedAllBase { selectedBase.removeAll() }
            else { selectedBase.formUnion(base) }
        }
    }
    
    
    func toggleSelectDiacritic() {
        withAnimation {
            if hasSelectedAllDiacritic { selectedDiacritic.removeAll() }
            else { selectedDiacritic.formUnion(diacritic) }
        }
    }
    
    
    func toggleSelectCombinatory() {
        withAnimation {
            if hasSelectedAllCombinatory { selectedCombinatory.removeAll() }
            else { selectedCombinatory.formUnion(combinatory) }
        }
    }
    
    
    func toggleSelectCombinatoryDiacritic() {
        withAnimation {
            if hasSelectedAllCombinatoryDiacritic { selectedCombinatoryDiacritic.removeAll() }
            else { selectedCombinatoryDiacritic.formUnion(combinatoryDiacritic) }
        }
    }
    
    
    func toggleSelectNew() {
        withAnimation {
            if hasSelectedAllNew { selectedNew.removeAll() }
            else { selectedNew.formUnion(new) }
        }
    }
}

struct KanaToolbarButton: View {
    let title: String
    let isOn: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle ) {
            HStack {
                Image(systemName: isOn ? "checkmark.circle.fill" : "checkmark.circle")
                    .tint(isOn ? .mint : .gray)
                Text(title)
                    .tint(.primary)
            }
            .padding(8)
            .clipShape(.capsule)
        }
    }
}

struct KanaTrainingButtonView: View {
    @State var showLevelUpInfo: Bool = false
    @State var showAllInARowInfo: Bool = false
    let onLevelUpsTapped: () -> Void
    let onAllInARowTapped: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                HStack(spacing: 20) {
                    Button("Level ups") { onLevelUpsTapped() }.buttonStyle(.glassProminent)
                        .popover(isPresented: $showLevelUpInfo, arrowEdge: .bottom) {
                            VStack(alignment: .leading) {
                                Text("Level ups")
                                    .font(.headline)
                                Text("Test your knowledge on 10 random kanas chosen from the selection with increasing difficulty.")
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .presentationCompactAdaptation(.popover)
                            .padding()
                            .padding(.vertical, 20)
                        }
                    
                    Button("All in a row") { onAllInARowTapped() }.buttonStyle(.glassProminent)
                        .popover(isPresented: $showAllInARowInfo, arrowEdge: .bottom) {
                            VStack(alignment: .leading) {
                                Text("All in a row")
                                    .font(.headline)
                                Text("Try to get all selected kanas right in a row !")
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .presentationCompactAdaptation(.popover)
                            .padding()
                            .padding(.vertical, 20)
                        }
                }
                HStack {
                    Spacer()
                    Button(action: { showLevelUpInfo = true }, label: { Image(systemName: "questionmark.circle")})
                        .buttonStyle(.glass)
                        .padding(.horizontal)
                }
            }
        }.onChange(of: showLevelUpInfo) { oldValue, newValue in
            if oldValue && !newValue {
                showAllInARowInfo = true
            }
        }
    }
}

#Preview {
    Train()
}
