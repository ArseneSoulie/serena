import SwiftUI

struct Mnemonic {
    let explanation: String
    let hint: String?
    let images: [Image]
    
    init(explanation: String, hint: String? = nil, images: [Image] = []) {
        self.explanation = explanation
        self.hint = hint
        self.images = images
    }
}

struct Mnemonics {
    let wkMnemonic: Mnemonic?
    let userProvidedMnemonic: Mnemonic?
    
    init(wkMnemonic: Mnemonic? = nil, userProvidedMnemonic: Mnemonic? = nil) {
        self.wkMnemonic = wkMnemonic
        self.userProvidedMnemonic = userProvidedMnemonic
    }
}

struct MnemonicsView: View {
    let title: String
    let mnemonics: Mnemonics
    @State private var showDetails = false
    
    // TODO: - this
    func addOrEditUserMnemonic() {
        
    }
    
    var body: some View {
        DisclosureGroup(title, isExpanded: $showDetails) {
                VStack(alignment: .leading) {
                    if let wkMnemonic = mnemonics.wkMnemonic {
                        MnemonicView(mnemonic: wkMnemonic)
                    }
                    if let userProvidedMnemonic = mnemonics.userProvidedMnemonic {
                        MnemonicView(mnemonic: userProvidedMnemonic)
                        HStack {
                            Button("Edit mnemonic", systemImage: "pencil.circle") { addOrEditUserMnemonic() }
                            Spacer()
                        }
                    }
                    HStack {
                        Button("Add a mnemonic", systemImage: "plus") { addOrEditUserMnemonic() }
                        Spacer()
                    }
                }.padding()
        }
    }
}

struct MnemonicView: View {
    let mnemonic: Mnemonic
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(mnemonic.explanation)
            if let hint = mnemonic.hint, !hint.isEmpty {
                HStack {
                    Image(systemName: "info.bubble.fill")
                    Text(hint)
                }
                .foregroundStyle(.secondary)
            }
        }.font(.callout)
    }
}
