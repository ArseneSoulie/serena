import SwiftUI

struct KanaLineGroupView: View {
    let title: String
    let lines: [KanaLine]
    @Binding var selectedLines: Set<KanaLine>
    
    @State var isExpanded: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            DisclosureGroup(isExpanded: $isExpanded) {
                Grid(alignment: .leading) {
                    ForEach(lines) { kanaLine in
                        KanaLineView(
                            kanaLine: kanaLine,
                            isOn: $selectedLines[containsLine: kanaLine]
                        )
                    }
                }.padding(.vertical, 8)
            } label: {
                HStack {
                    Button(action: toggleSelectBase) {
                        Image(systemName: hasSelectedAll ? "checkmark.circle.fill" : "checkmark.circle")
                    }
                        .tint(hasSelectedAll ? .mint : .gray)
                        .buttonSizing(.fitted)
                        .buttonStyle(.bordered)
                    Text("\(title) \(selectedLines.kanaCount)/\(lines.kanaCount)").font(.subheadline)
                }
            }
            Divider()
        }
        .padding(.horizontal)
        .tint(selectedLines.isEmpty ? .secondary : .mint)
    }
    
    var hasSelectedAll: Bool {
        selectedLines.count == lines.count
    }
    
    func toggleSelectBase() {
        withAnimation {
            if hasSelectedAll { selectedLines.removeAll() }
            else { selectedLines.formUnion(lines) }
        }
    }
}
