import SwiftUI

struct FastSelectPopoverView: View {
    @Binding var selectedBase: Set<KanaLine>
    @Binding var selectedDiacritic: Set<KanaLine>
    @Binding var selectedCombinatory: Set<KanaLine>
    @Binding var selectedCombinatoryDiacritic: Set<KanaLine>
    @Binding var selectedExtendedKatakana: Set<KanaLine>

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(localized("All"), action: selectAll)
                Spacer()
                Button(localized("Clear"), action: clearAll)
            }
            Divider()
            FastSelectToggleButton(
                title: localized("Base"),
                isOn: $selectedBase[containsLines: base]
            )
            FastSelectToggleButton(
                title: localized("Diacritics"),
                isOn: $selectedDiacritic[containsLines: diacritic]
            )
            FastSelectToggleButton(
                title: localized("Combinatory"),
                isOn: $selectedCombinatory[containsLines: combinatory]
            )
            FastSelectToggleButton(
                title: localized("Combinatory diacritics"),
                isOn: $selectedCombinatoryDiacritic[containsLines: combinatoryDiacritic]
            )
            FastSelectToggleButton(
                title: localized("Extended katakana"),
                isOn: $selectedExtendedKatakana[containsLines: extendedKatakana]
            )
        }
        .padding()
        .presentationCompactAdaptation(.popover)
    }

    func selectAll() {
        selectedBase.formUnion(base)
        selectedDiacritic.formUnion(diacritic)
        selectedCombinatory.formUnion(combinatory)
        selectedCombinatoryDiacritic.formUnion(combinatoryDiacritic)
        selectedExtendedKatakana.formUnion(extendedKatakana)
    }

    func clearAll() {
        selectedBase.removeAll()
        selectedDiacritic.removeAll()
        selectedCombinatory.removeAll()
        selectedCombinatoryDiacritic.removeAll()
        selectedExtendedKatakana.removeAll()
    }
}

struct FastSelectToggleButton: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Button(action: {
            withAnimation { isOn.toggle() }
        }) {
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
