import DesignSystem
import SwiftUI

struct KanaMnemonicData: Identifiable {
    let id: UUID
    let kanaString: String
    let explanation: String
}

public struct KanaMnemonicsPage: View {
    let mnemonics: [KanaMnemonicData]
    @State private var isCreateMnemonicSheetPresented: Bool = false
    @State private var presentedMnemonic: KanaMnemonicData? = nil
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(mnemonics) { mnemonic in
                    Text(mnemonic.kanaString)
                        .font(.headline)
                    Text(mnemonic.explanation)
                        .font(.subheadline)
                    Button("Add and draw your own mnemonic") {
                        presentedMnemonic = mnemonic
                    }
                    HStack {
                        
                    }
                }
            }
        }
        .sheet(item: $presentedMnemonic, content: {
            KanaDrawingView(kanaString: $0.kanaString)
        })
    }
}

#Preview {
    KanaMnemonicsPage(mnemonics: mockData)
}

let mockData: [KanaMnemonicData] = [
    .init(id: UUID(), kanaString: "あ", explanation: "a ablablab lzkdblzadkb lzak balzdk baz l"),
    .init(id: UUID(), kanaString: "い", explanation: "i ablablab lzkdblzadkb lzak balzdk baz l"),
    .init(id: UUID(), kanaString: "う", explanation: "u ablablab lzkdblzadkb lzak balzdk baz l"),
    .init(id: UUID(), kanaString: "え", explanation: "e ablablab lzkdblzadkb lzak balzdk baz l"),
    .init(id: UUID(), kanaString: "お", explanation: "o ablablab lzkdblzadkb lzak balzdk baz l"),
]
