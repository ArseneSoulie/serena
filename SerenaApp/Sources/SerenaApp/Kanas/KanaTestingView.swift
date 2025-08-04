//
//  KanaTestingView.swift
//  SerenaApp
//
//  Created by A S on 01/08/2025.
//

struct KanaLine: Identifiable, Hashable {
    let name: String
    let kanas: [String?]
    
    var id: String { name }
}

let baseKatakana: [KanaLine] = [
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

let diacriticKatakana: [KanaLine] = [
    .init(name:"g-" , kanas:["ga","gi","gu","ge","go"]),
    .init(name:"z-" , kanas:["za","ji","zu","ze","zo"]),
    .init(name:"d-" , kanas:["da","di","du","de","do"]),
    .init(name:"b-" , kanas:["ba","bi","bu","be","bo"]),
    .init(name:"p-" , kanas:["pa","pi","pu","pe","po"]),
]

let combinatoryKatakana: [KanaLine] = [
    .init(name:"ky-" , kanas:["kya","kyu","kyo"]),
    .init(name:"sh-" , kanas:["sha","shu","sho"]),
    .init(name:"ch-" , kanas:["cha","chu","cho"]),
    .init(name:"ny-" , kanas:["nya","nyu","nyo"]),
    .init(name:"hy-" , kanas:["hya","hyu","hyo"]),
    .init(name:"my-" , kanas:["mya","myu","myo"]),
    .init(name:"ry-" , kanas:["rya","ryu","ryo"]),
]

let combinatoryDiacriticKatakana: [KanaLine] = [
    .init(name:"gy-" , kanas:["gya","gyu","gyo"]),
    .init(name:"j-" , kanas:["ja","ju","jo"]),
    .init(name:"dy-" , kanas:["dya","dyu","dyo"]),
    .init(name:"by-" , kanas:["bya","byu","byo"]),
    .init(name:"py-" , kanas:["pya","pyu","pyo"]),
]

let newKatakana: [KanaLine] = [
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
                    ForEach(kanaLine.kanas, id: \.self) { kana in
                        Text(displayAsKana ? kana?.romajiToKatakana ?? "ア" : kana ?? "a")
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

struct LineGroup: View {
    let title: String
    let lines: [KanaLine]
    @Binding var selectedRows: Set<KanaLine>
    
    var totalKanas: Int {
        lines.reduce(0) { partialResult, line in
            partialResult + line.kanas.count(where: { $0 != nil} )
        }
    }
    
    var selectedKanas: Int {
        selectedRows.reduce(0) { partialResult, line in
            partialResult + line.kanas.count(where: { $0 != nil} )
        }
    }
    
    @State var isExpanded: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            DisclosureGroup("\(title) \(selectedKanas)/\(totalKanas)", isExpanded: $isExpanded) {
                Grid(alignment: .leading) {
                    ForEach(lines) { kanaLine in
                        Line(kanaLine: kanaLine, isOn: $selectedRows[containsLine: kanaLine])
                    }
                }
            }
            Divider()
        }.padding(.horizontal)
    }
}

extension EnvironmentValues {
    @Entry var displayAsKana: Bool = true
}

struct Train: View {
    @State var selectedBaseKatakana: Set<KanaLine> = []
    @State var selectedDiacriticKatakana: Set<KanaLine> = []
    @State var selectedCombinatoryKatakana: Set<KanaLine> = []
    @State var selectedCombinatoryDiacriticKatakana: Set<KanaLine> = []
    @State var selectedNewKatakana: Set<KanaLine> = []
    
    @State var showsFastSelect: Bool = false
    @State var displayAsKana: Bool = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Select the rows you want to train on and pick a mode below.")
                        .font(.subheadline)
                        .padding()
                    LineGroup(title: "Base katakana", lines: baseKatakana, selectedRows: $selectedBaseKatakana, isExpanded: false)
                        .tint(selectedBaseKatakana.isEmpty ? .secondary : .mint)
                    LineGroup(title: "Diacritics (dakuten/handakuten)", lines: diacriticKatakana, selectedRows: $selectedDiacriticKatakana, isExpanded: false)
                        .tint(selectedDiacriticKatakana.isEmpty ? .secondary : .mint)
                    LineGroup(title: "Combinatory", lines: combinatoryKatakana, selectedRows: $selectedCombinatoryKatakana, isExpanded: false)
                        .tint(selectedCombinatoryKatakana.isEmpty ? .secondary : .mint)
                    LineGroup(title: "Combinatory diacritics", lines: combinatoryDiacriticKatakana, selectedRows: $selectedCombinatoryDiacriticKatakana, isExpanded: false)
                        .tint(selectedCombinatoryDiacriticKatakana.isEmpty ? .secondary : .mint)
                    LineGroup(title: "New cases", lines: newKatakana, selectedRows: $selectedNewKatakana, isExpanded: true)
                        .tint(selectedNewKatakana.isEmpty ? .secondary : .mint)
                    Spacer()
                        .frame(height: 80)
                }
                .visualEffect({ initial, geom in
                    initial.colorEffect(ShaderLibrary.color())
                })
                
                 
            }
            .environment(\.displayAsKana, displayAsKana)
            .overlay(alignment: .bottom) {
                ZStack {
                    KanaTrainingButtonView()
                }
            }
            
            .navigationTitle("Kana training")
            .toolbar {
                Button(displayAsKana ? "ア" : "A") { withAnimation { displayAsKana.toggle()} }
                Button("Fast select") { showsFastSelect.toggle() }
                    .popover (isPresented: $showsFastSelect) {
                        VStack(alignment: .leading) {
                            KanaToolbarButton(
                                title: "Everything",
                                isOn: hasSelectedEverything,
                                onToggle: toggleEverythingSelection
                            )
                            KanaToolbarButton(
                                title: "Base katakana",
                                isOn: hasSelectedAllBaseKatakana,
                                onToggle: toggleSelectBaseKatakana
                            )
                            KanaToolbarButton(
                                title: "Diacritics",
                                isOn: hasSelectedAllDiacriticKatakana,
                                onToggle: toggleSelectDiacriticKatakana
                            )
                            KanaToolbarButton(
                                title: "Combinatory",
                                isOn: hasSelectedAllCombinatoryKatakana,
                                onToggle: toggleSelectCombinatoryKatakana
                            )
                            KanaToolbarButton(
                                title: "Combinatory diacritics",
                                isOn: hasSelectedAllCombinatoryDiacriticKatakana,
                                onToggle: toggleSelectCombinatoryDiacriticKatakana
                            )
                            KanaToolbarButton(
                                title: "New cases",
                                isOn: hasSelectedAllNewKatakana,
                                onToggle: toggleSelectNewKatakana
                            )
                        }
                        .padding()
                        .presentationCompactAdaptation(.popover)
                    }
            }
        }
    }
    
    var hasSelectedEverything: Bool {
        hasSelectedAllBaseKatakana &&
        hasSelectedAllDiacriticKatakana &&
        hasSelectedAllCombinatoryKatakana &&
        hasSelectedAllCombinatoryDiacriticKatakana &&
        hasSelectedAllNewKatakana
    }
    
    func toggleEverythingSelection() {
        withAnimation {
            if hasSelectedEverything {
                selectedBaseKatakana.removeAll()
                selectedDiacriticKatakana.removeAll()
                selectedCombinatoryKatakana.removeAll()
                selectedCombinatoryDiacriticKatakana.removeAll()
                selectedNewKatakana.removeAll()
            } else {
                selectedBaseKatakana.formUnion(baseKatakana)
                selectedDiacriticKatakana.formUnion(diacriticKatakana)
                selectedCombinatoryKatakana.formUnion(combinatoryKatakana)
                selectedCombinatoryDiacriticKatakana.formUnion(combinatoryDiacriticKatakana)
                selectedNewKatakana.formUnion(newKatakana)
            }
        }
    }
    
    var hasSelectedAllBaseKatakana: Bool {
        selectedBaseKatakana.count == baseKatakana.count
    }
    
    func toggleSelectBaseKatakana() {
        withAnimation {
            if hasSelectedAllBaseKatakana { selectedBaseKatakana.removeAll() }
            else { selectedBaseKatakana.formUnion(baseKatakana) }
        }
    }
    
    var hasSelectedAllDiacriticKatakana: Bool {
        selectedDiacriticKatakana.count == diacriticKatakana.count
    }
    
    func toggleSelectDiacriticKatakana() {
        withAnimation {
            if hasSelectedAllDiacriticKatakana { selectedDiacriticKatakana.removeAll() }
            else { selectedDiacriticKatakana.formUnion(diacriticKatakana) }
        }
    }
    
    var hasSelectedAllCombinatoryKatakana: Bool {
        selectedCombinatoryKatakana.count == combinatoryKatakana.count
    }
    
    func toggleSelectCombinatoryKatakana() {
        withAnimation {
            if hasSelectedAllCombinatoryKatakana { selectedCombinatoryKatakana.removeAll() }
            else { selectedCombinatoryKatakana.formUnion(combinatoryKatakana) }
        }
    }
    
    var hasSelectedAllCombinatoryDiacriticKatakana: Bool {
        selectedCombinatoryDiacriticKatakana.count == combinatoryDiacriticKatakana.count
    }
    
    func toggleSelectCombinatoryDiacriticKatakana() {
        withAnimation {
            if hasSelectedAllCombinatoryDiacriticKatakana { selectedCombinatoryDiacriticKatakana.removeAll() }
            else { selectedCombinatoryDiacriticKatakana.formUnion(combinatoryDiacriticKatakana) }
        }
    }
    
    var hasSelectedAllNewKatakana: Bool {
        selectedNewKatakana.count == newKatakana.count
    }
    
    func toggleSelectNewKatakana() {
        withAnimation {
            if hasSelectedAllNewKatakana { selectedNewKatakana.removeAll() }
            else { selectedNewKatakana.formUnion(newKatakana) }
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
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
    var body: some View {
        VStack {
            HStack {
                Button("Level ups") { }.buttonStyle(.borderedProminent)
                    .popover(isPresented: $showLevelUpInfo, arrowEdge: .bottom) {
                        Text("Test your knowledge on 10 random kanas chosen from the selection with increasing difficulty.")
                            .fixedSize(horizontal: false, vertical: true)
                            .presentationCompactAdaptation(.popover)
                            .padding()
                            .padding(.vertical, 20)
                    }
                
                Button("All in a row") { }.buttonStyle(.borderedProminent)
                    .popover(isPresented: $showAllInARowInfo, arrowEdge: .bottom) {
                        Text("Try to get all selected kanas right in a row !")
                            .fixedSize(horizontal: false, vertical: true)
                            .presentationCompactAdaptation(.popover)
                            .padding()
                            .padding(.vertical, 20)
                    }
                Button("", systemImage: "questionmark.circle") { showLevelUpInfo = true }
            }
        }.onChange(of: showLevelUpInfo) { oldValue, newValue in
            if oldValue && !newValue {
                showAllInARowInfo = true
            }
        }
    }
}

struct InfoPopover: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Level ups")
                .font(.headline)
            Text("Test your knowledge on 10 random kanas chosen from the selection with increasing difficulty.")
                .padding()
            Divider()
                .padding()
            Text("All in a row")
                .font(.headline)
            Text("Try to get all selected kanas right in a row !")
                .padding()
        }.frame(width: 300)
    }
}

#Preview {
    Train()
}
