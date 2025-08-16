import SwiftUI

struct KanaLineGroupView: View {
    let title: String
    let subtitle: String?
    let lines: [KanaLine]
    @Binding var selectedLines: Set<KanaLine>

    @State var isExpanded: Bool = true

    let showRomaji: Bool
    let kanaSelectionType: KanaSelectionType

    init(
        title: String,
        subtitle: String? = nil,
        lines: [KanaLine],
        selectedLines: Binding<Set<KanaLine>>,
        showRomaji: Bool,
        kanaSelectionType: KanaSelectionType,
    ) {
        self.title = title
        self.subtitle = subtitle
        self.lines = lines
        _selectedLines = selectedLines
        self.showRomaji = showRomaji
        self.kanaSelectionType = kanaSelectionType
    }

    var body: some View {
        VStack(alignment: .leading) {
            DisclosureGroup(isExpanded: $isExpanded) {
                VStack {
                    if let subtitle {
                        HStack {
                            Image(systemName: "lightbulb.min")
                            Text(subtitle)
                                .typography(.footnote)
                        }
                    }
                    Grid(alignment: .leading) {
                        ForEach(lines) { kanaLine in
                            KanaLineView(
                                kanaLine: kanaLine,
                                showRomaji: showRomaji,
                                kanaSelectionType: kanaSelectionType,
                                isOn: $selectedLines[containsLine: kanaLine],
                            )
                        }
                    }.padding(.vertical, 8)
                }
            } label: {
                HStack {
                    Button(action: toggleSelectBase) {
                        Image(systemName: hasSelectedAll ? "checkmark.circle.fill" : "checkmark.circle")
                    }
                    .tint(hasSelectedAll ? .green : .gray)
                    Text("\(title) \(selectedLines.kanaCount)/\(lines.kanaCount)")
                        .bold()
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
