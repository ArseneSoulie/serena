import SwiftUI

struct KanaLineGroupView: View {
    let title: String
    let lines: [KanaLine]
    @Binding var selectedLines: Set<KanaLine>

    @State var isExpanded: Bool = true

    let showRomaji: Bool
    let kanaSelectionType: KanaSelectionType
    let tint: Color

    init(
        title: String,
        lines: [KanaLine],
        selectedLines: Binding<Set<KanaLine>>,
        showRomaji: Bool,
        kanaSelectionType: KanaSelectionType,
        tint: Color,
    ) {
        self.title = title
        self.lines = lines
        _selectedLines = selectedLines
        self.showRomaji = showRomaji
        self.kanaSelectionType = kanaSelectionType
        self.tint = tint
    }

    var body: some View {
        VStack(alignment: .leading) {
            DisclosureGroup(isExpanded: $isExpanded) {
                Grid(alignment: .leading) {
                    ForEach(lines) { kanaLine in
                        KanaLineView(
                            kanaLine: kanaLine,
                            showRomaji: showRomaji,
                            kanaSelectionType: kanaSelectionType,
                            tint: tint,
                            isOn: $selectedLines[containsLine: kanaLine],
                        )
                    }
                }.padding(.vertical, 8)
            } label: {
                HStack {
                    Button(action: toggleSelectBase) {
                        HStack {
                            Image(systemName: hasSelectedAll ? "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundStyle(hasSelectedAll ? tint : .secondary)
                            Text("\(title) \(selectedLines.kanaCount)/\(lines.kanaCount)")
                                .bold(!selectedLines.isEmpty)
                                .foregroundStyle(!selectedLines.isEmpty ? Color.primary : Color.secondary)
                        }
                    }
                }
            }
            Divider()
        }
        .padding(.horizontal)
        .tint(selectedLines.isEmpty ? .secondary : .primary)
    }

    var hasSelectedAll: Bool {
        selectedLines.count == lines.count
    }

    func toggleSelectBase() {
        withAnimation {
            if hasSelectedAll { selectedLines.removeAll() } else { selectedLines.formUnion(lines) }
        }
    }
}
