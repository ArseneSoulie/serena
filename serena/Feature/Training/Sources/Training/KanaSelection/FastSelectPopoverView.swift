import SwiftUI

struct FastSelectPopoverView: View {
    @Binding var selectedBase: Set<KanaLine>
    @Binding var selectedDiacritic: Set<KanaLine>
    @Binding var selectedCombinatory: Set<KanaLine>
    @Binding var selectedCombinatoryDiacritic: Set<KanaLine>
    @Binding var selectedExtendedKatakana: Set<KanaLine>

    var body: some View {
        VStack(alignment: .leading) {
            Text(.fastSelect)
                .typography(.title2)
            Spacer()
            HStack {
                Button(.all, action: selectAll)
                Spacer()
                Button(.clear, action: clearAll)
            }
            Divider()
            FastSelectToggleButton(
                title: .base,
                tint: CatagoryColor.base,
                isOn: $selectedBase[containsLines: base],
            )
            FastSelectToggleButton(
                title: .diacritics,
                tint: CatagoryColor.diacritic,
                isOn: $selectedDiacritic[containsLines: diacritic],
            )
            FastSelectToggleButton(
                title: .combinatory,
                tint: CatagoryColor.combinatory,
                isOn: $selectedCombinatory[containsLines: combinatory],
            )
            FastSelectToggleButton(
                title: .combinatoryDiacritics,
                tint: CatagoryColor.combinarotyDiacritic,
                isOn: $selectedCombinatoryDiacritic[containsLines: combinatoryDiacritic],
            )
            FastSelectToggleButton(
                title: .extendedKatakana,
                tint: CatagoryColor.extendedKatakana,
                isOn: $selectedExtendedKatakana[containsLines: extendedKatakana],
            )
        }
        .padding()
        .presentationCompactAdaptation(.popover)
    }

    func selectAll() {
        withAnimation {
            selectedBase.formUnion(base)
            selectedDiacritic.formUnion(diacritic)
            selectedCombinatory.formUnion(combinatory)
            selectedCombinatoryDiacritic.formUnion(combinatoryDiacritic)
            selectedExtendedKatakana.formUnion(extendedKatakana)
        }
    }

    func clearAll() {
        withAnimation {
            selectedBase.removeAll()
            selectedDiacritic.removeAll()
            selectedCombinatory.removeAll()
            selectedCombinatoryDiacritic.removeAll()
            selectedExtendedKatakana.removeAll()
        }
    }
}

struct FastSelectToggleButton: View {
    let title: LocalizedStringResource
    let tint: Color
    @Binding var isOn: Bool

    var body: some View {
        Button(action: {
            withAnimation { isOn.toggle() }
        }) {
            HStack {
                Image(systemName: isOn ? "checkmark.circle.fill" : "checkmark.circle")
                    .tint(isOn ? tint : .gray)
                Text(title)
                    .tint(isOn ? .primary : .secondary)
            }
            .padding(8)
            .clipShape(.capsule)
        }
    }
}
