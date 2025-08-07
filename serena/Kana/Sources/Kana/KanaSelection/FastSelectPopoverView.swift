import SwiftUI

struct FastSelectPopoverView: View {
    let kanaType: KanaType
    
    @Binding var selectedBase: Set<KanaLine>
    @Binding var selectedDiacritic: Set<KanaLine>
    @Binding var selectedCombinatory: Set<KanaLine>
    @Binding var selectedCombinatoryDiacritic: Set<KanaLine>
    @Binding var selectedNew: Set<KanaLine>
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(localized("All"), action: selectAll)
                Spacer()
                Button(localized("Clear"), action: clearAll)
            }
            Divider()
            FastSelectToggleButton(
                title: "【\("ka".format(kanaType))】\(localized("Base")) \(kanaType.rawValue)",
                isOn: $selectedBase[containsLines: base]
            )
            FastSelectToggleButton(
                title: "【\("ga".format(kanaType))】\(localized("Diacritics"))",
                isOn: $selectedDiacritic[containsLines: diacritic]
            )
            FastSelectToggleButton(
                title: "【\("sha".format(kanaType))】\(localized("Combinatory"))",
                isOn: $selectedCombinatory[containsLines: combinatory]
            )
            FastSelectToggleButton(
                title: "【\("ja".format(kanaType))】\(localized("Combinatory diacritics"))",
                isOn: $selectedCombinatoryDiacritic[containsLines: combinatoryDiacritic]
            )
            if case .katakana = kanaType {
                FastSelectToggleButton(
                    title: "【新】\(localized("New cases"))",
                    isOn: $selectedNew[containsLines: new]
                )
            }
        }
        .padding()
        .presentationCompactAdaptation(.popover)
    }
    
    func selectAll() {
        selectedBase.formUnion(base)
        selectedDiacritic.formUnion(diacritic)
        selectedCombinatory.formUnion(combinatory)
        selectedCombinatoryDiacritic.formUnion(combinatoryDiacritic)
        if kanaType == .katakana {
            selectedNew.formUnion(new)
        }
    }
    
    func clearAll() {
        selectedBase.removeAll()
        selectedDiacritic.removeAll()
        selectedCombinatory.removeAll()
        selectedCombinatoryDiacritic.removeAll()
        if kanaType == .katakana {
            selectedNew.removeAll()
        }
    }
}


struct FastSelectToggleButton: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: {
            withAnimation { isOn.toggle() }
        } ) {
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
