import SwiftUI

struct KanaLineView: View {
    let kanaLine: KanaLine
    let showRomaji: Bool
    let kanaSelectionType: KanaSelectionType

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
                            .background { Color(white: 0.97) }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .opacity(kana == nil ? 0 : 1)
                    }
                }
                .padding(.all, 4)
                .foregroundStyle(isOn ? Color(white: 0.2) : Color(white: 0.4))
                .background { isOn ? .mint : Color(white: 0.92) }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(alignment: .topTrailing) {
                    if isOn {
                        ZStack {
                            Color.white
                                .frame(width: 24, height: 24)
                                .clipShape(.circle)
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.green)
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

    var body: some View {
        switch kanaSelectionType {
        case .hiragana:
            VStack {
                Text(text.romajiToHiragana).bold()
                if showRomaji {
                    Text(text.lowercased())
                        .typography(.caption)
                }
            }
        case .katakana:
            VStack {
                Text(text.romajiToKatakana).bold()
                if showRomaji {
                    Text(text.uppercased())
                        .typography(.caption)
                }
            }
        case .both:
            HStack {
                VStack {
                    Text(text.romajiToHiragana).bold()
                    if showRomaji {
                        Text(text.lowercased())
                            .typography(.caption)
                    }
                }
                VStack {
                    Text(text.romajiToKatakana).bold()
                    if showRomaji {
                        Text(text.uppercased())
                            .typography(.caption)
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var isOn = true
    Grid {
        KanaLineView(
            kanaLine: .init(name: "r-", kanas: ["ra", "ri", "ru", "re", "ro"]),
            showRomaji: true,
            kanaSelectionType: .hiragana,
            isOn: $isOn,
        )
        KanaLineView(
            kanaLine: .init(name: "r-", kanas: ["ra", "ri", "ru", "re", "ro"]),
            showRomaji: true,
            kanaSelectionType: .katakana,
            isOn: $isOn,
        )
        KanaLineView(
            kanaLine: .init(name: "r-", kanas: ["ra", "ri", "ru", "re", "ro"]),
            showRomaji: false,
            kanaSelectionType: .hiragana,
            isOn: $isOn,
        )
        KanaLineView(
            kanaLine: .init(name: "r-", kanas: ["ra", "ri", "ru", "re", "ro"]),
            showRomaji: false,
            kanaSelectionType: .hiragana,
            isOn: $isOn,
        )
    }
}
