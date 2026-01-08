import SwiftUI

struct KanaLineView: View {
    let kanaLine: KanaLine
    let showRomaji: Bool
    let kanaSelectionType: KanaSelectionType
    let tint: Color

    @Binding var isOn: Bool

    var body: some View {
        GridRow {
            Button(
                action: toggleLine,
                label: { Text(kanaLine.id).padding(8) },
            )
            .tint(.primary)
            .gridColumnAlignment(.trailing)

            Button(action: toggleLine) {
                HStack(spacing: 4) {
                    ForEach(kanaLine.kanas, id: \.kanaId) { kana in
                        KanaWritingPreview(text: kana, showRomaji: showRomaji, kanaSelectionType: kanaSelectionType)
                            .padding(.all, 6)
                            .frame(maxWidth: .infinity)
                            .opacity(kana == nil ? 0 : 1)

                        if kana != kanaLine.kanas.last {
                            Divider().padding(.vertical)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.all, 4)
                .foregroundStyle(isOn ? Color.primary : Color.secondary)
                .background(
                    isOn ? tint.mix(with: Color.bgColor, by: 0.8).opacity(0.5) : Color.secondary.opacity(0.1),
                    in: .rect,
                )
                .cornerRadius(.default)
                .border(
                    style: isOn ? tint.mix(with: Color(white: 0.9), by: 0.4) : Color.secondary.opacity(0.1),
                    width: .strong,
                    cornerRadius: .moderate,
                )
            }

            Button(
                action: toggleLine,
                label: {
                    Image(systemName: isOn ? "checkmark.circle.fill" : "checkmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(isOn ? tint : Color(white: 0.8))
                        .padding(8)
                        .padding(.trailing, 8)
                },
            )
        }
    }

    func toggleLine() {
        withAnimation { isOn.toggle() }
    }
}

struct KanaWritingPreview: View {
    let text: String
    let showRomaji: Bool
    let kanaSelectionType: KanaSelectionType

    init(text: String?, showRomaji: Bool, kanaSelectionType: KanaSelectionType) {
        self.text = text ?? ""
        self.showRomaji = showRomaji
        self.kanaSelectionType = kanaSelectionType
    }

    var kanaToShow: String {
        switch kanaSelectionType {
        case .hiragana: text.romajiToHiragana
        case .katakana: text.romajiToKatakana
        case .both: "\(text.romajiToHiragana) \(text.romajiToKatakana)"
        }
    }

    var romajiToShow: String {
        switch kanaSelectionType {
        case .hiragana: text.lowercased()
        case .katakana: text.uppercased()
        case .both: "\(text.lowercased()) \(text.uppercased())"
        }
    }

    var body: some View {
        VStack {
            Text(kanaToShow).bold()
            if showRomaji {
                Text(romajiToShow)
                    .typography(.caption)
            }
        }
    }
}

#Preview {
    @Previewable @State var isOn = true
    @Previewable @State var isnOn = false
    ScrollView {
        Grid {
            KanaLineView(
                kanaLine: .init(name: "r-", kanas: ["ra", "ri", "ru", "re", "ro"]),
                showRomaji: true,
                kanaSelectionType: .hiragana,
                tint: .green,
                isOn: $isOn,
            )
            KanaLineView(
                kanaLine: .init(name: "r-", kanas: ["ra", "ri", "ru", "re", "ro"]),
                showRomaji: true,
                kanaSelectionType: .katakana,
                tint: .green,
                isOn: $isnOn,
            )
            KanaLineView(
                kanaLine: .init(name: "r-", kanas: ["ra", "ri", "ru", "re", "ro"]),
                showRomaji: false,
                kanaSelectionType: .hiragana,
                tint: .green,
                isOn: $isOn,
            )
            KanaLineView(
                kanaLine: .init(name: "r-", kanas: ["ra", "ri", "ru", "re", "ro"]),
                showRomaji: false,
                kanaSelectionType: .hiragana,
                tint: .green,
                isOn: $isnOn,
            )
        }
    }
}
