import DesignSystem
import KanjiVGParser
import SwiftUI

struct KanaMnemonicData: Identifiable {
    let id: UUID = .init()
    let kanaString: String
    let explanation: String
}

public struct KanaMnemonicsPage: View {
    let mnemonics: [KanaMnemonicData] = mockData
    @State private var isCreateMnemonicSheetPresented: Bool = false
    @State private var presentedMnemonic: KanaMnemonicData?

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(mnemonics) { mnemonic in
                    Text(mnemonic.kanaString)
                        .typography(.headline)
                    Text(mnemonic.explanation)
                    Button("Add and draw your own mnemonic") {
                        presentedMnemonic = mnemonic
                    }
                    HStack {}
                }
            }
        }
        .sheet(item: $presentedMnemonic, content: {
            let url = Bundle.module.url(forResource: $0.kanaString, withExtension: "svg")
            DrawingView(
                contentView: {
                    KanjiStrokes(from: url)?.stroke(lineWidth: 15)
                        .foregroundStyle(Color(white: 0.8))
                        .aspectRatio(1, contentMode: .fit)
                        .padding(48)
                },
                onSave: { _ in },
            )
        })
    }
}

#Preview {
    KanaMnemonicsPage()
}

let mockData: [KanaMnemonicData] = [
    .init(kanaString: "あ", explanation: "a ablablab lzkdblzadkb lzak balzdk baz l"),
    .init(kanaString: "い", explanation: "i ablablab lzkdblzadkb lzak balzdk baz l"),
    .init(kanaString: "う", explanation: "u ablablab lzkdblzadkb lzak balzdk baz l"),
    .init(kanaString: "え", explanation: "e ablablab lzkdblzadkb lzak balzdk baz l"),
    .init(kanaString: "お", explanation: "o ablablab lzkdblzadkb lzak balzdk baz l"),
]
