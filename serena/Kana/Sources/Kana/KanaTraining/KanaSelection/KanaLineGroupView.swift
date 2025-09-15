import SwiftUI

struct KanaLineGroupView: View {
    let title: String
    let lines: [KanaLine]
    @Binding var selectedLines: Set<KanaLine>

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
        Section {
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
            Divider()
        } header: {
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
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.bgColor, in: .capsule)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                Spacer()
            }
        }
        .padding(.horizontal)
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
