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
                            .background { isOn ? Color(white: 1) : Color(white: 0.96) }
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .opacity(kana == nil ? 0 : 1)
                    }
                }
                .padding(.all, 4)
                .foregroundStyle(isOn ? Color(white: 0.2) : Color(white: 0.4))
                .background(isOn ? tint.mix(with: .white, by: 0.2) : Color(white: 0.92), in: .rect)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(alignment: .topTrailing) {
                    if isOn {
                        ZStack {
                            Color.bgColor
                                .frame(width: 26, height: 26)
                                .clipShape(.circle)
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(tint)
                        }
                        .offset(x: 8, y: -8)
                    }
                }
            }

            Text(kanaLine.id).hidden()
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
