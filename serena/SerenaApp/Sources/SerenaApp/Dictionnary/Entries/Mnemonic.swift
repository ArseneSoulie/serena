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
    var userProvidedMnemonic: Mnemonic?

    init(wkMnemonic: Mnemonic? = nil, userProvidedMnemonic: Mnemonic? = nil) {
        self.wkMnemonic = wkMnemonic
        self.userProvidedMnemonic = userProvidedMnemonic
    }
}

struct MnemonicsView: View {
    let title: String
    @Binding var mnemonics: Mnemonics
    @State private var showAddOrEditMnemonic: Bool = false
    @State private var showDetails = true

    var body: some View {
        DisclosureGroup(title, isExpanded: $showDetails) {
            VStack(alignment: .leading) {
                if let wkMnemonic = mnemonics.wkMnemonic {
                    MnemonicView(mnemonic: wkMnemonic)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                if mnemonics.userProvidedMnemonic == nil {
                    Button(action: { showAddOrEditMnemonic = true }, label: { Image(systemName: "plus") })
                }
                if let userProvidedMnemonic = mnemonics.userProvidedMnemonic {
                    if mnemonics.wkMnemonic != nil { Divider().padding() }
                    HStack(alignment: .top) {
                        MnemonicView(mnemonic: userProvidedMnemonic)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Button(action: { showAddOrEditMnemonic = true }, label: { Image(systemName: "pencil") })
                    }
                }
            }.padding()
        }
        .sheet(isPresented: $showAddOrEditMnemonic) {
            AddMnemonicView(title: title, mnemonics: mnemonics) { newMnemonic in
                withAnimation {
                    mnemonics.userProvidedMnemonic = newMnemonic
                    showAddOrEditMnemonic = false
                }
            }
        }
    }
}

struct MnemonicDraft {
    var explanation: String
    var hint: String
    var images: [Image]
}

extension Mnemonic {
    var draft: MnemonicDraft {
        .init(explanation: explanation, hint: hint ?? "", images: images)
    }
}

extension MnemonicDraft {
    var unwrappedMnemonic: Mnemonic? {
        if explanation.isEmpty, hint.isEmpty, images.isEmpty {
            return nil
        }
        return Mnemonic(explanation: explanation, hint: hint, images: images)
    }
}

struct AddMnemonicView: View {
    @State var mnemonicDraft: MnemonicDraft
    let wkMnemonic: Mnemonic?

    let title: String

    init(title: String, mnemonics: Mnemonics, onSaveUserMnemonicTapped: @escaping (Mnemonic?) -> Void) {
        self.title = title
        wkMnemonic = mnemonics.wkMnemonic
        mnemonicDraft = mnemonics.userProvidedMnemonic?.draft ?? .init(explanation: "", hint: "", images: [])
        self.onSaveUserMnemonicTapped = onSaveUserMnemonicTapped
    }

    let onSaveUserMnemonicTapped: (Mnemonic?) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Your mnemonic") {
                    TextField("Explanation", text: $mnemonicDraft.explanation, axis: .vertical)
                        .lineLimit(3 ... 10)
                    TextField("Optional hint", text: $mnemonicDraft.hint, axis: .vertical)
                        .lineLimit(1 ... 10)
                }.onSubmit {
                    onSaveUserMnemonicTapped(mnemonicDraft.unwrappedMnemonic)
                }
                #if os(macOS)
                .fixedSize(horizontal: false, vertical: true)
                #endif

                if let wkMnemonic {
                    Section("Wanikani mnemonic") {
                        Text(wkMnemonic.explanation).foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        if let wkHint = wkMnemonic.hint {
                            Text(wkHint).foregroundStyle(.tertiary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    #if os(macOS)
                    .fixedSize(horizontal: false, vertical: true)
                    #endif
                }
            }
            .toolbar {
                Button(action: { onSaveUserMnemonicTapped(nil) }, label: { Image(systemName: "trash") })
                Button(
                    action: { onSaveUserMnemonicTapped(mnemonicDraft.unwrappedMnemonic) },
                    label: { Image(systemName: "checkmark") },
                )
            }
            .navigationTitle(title)
            .presentationDetents([.medium, .large])
            #if os(macOS)
                .padding()
            #endif
        }
    }
}

#Preview {
    @Previewable @State var mnemonics: Mnemonics = .init(wkMnemonic: .init(
        explanation: "balbalba z foibzeof ibezfoi ubzif ubzfi uzbeifuzbe zub eizubfi zubla",
        hint: "okzdokzdozkdozk",
    ))
    @Previewable @State var mnemoniscs: Mnemonics = .init(wkMnemonic: nil)
    VStack {
        MnemonicsView(
            title: "Meaning mnemonics",
            mnemonics: $mnemonics,
        )

        MnemonicsView(
            title: "Meaning mnemonics",
            mnemonics: $mnemoniscs,
        )
    }
}

struct MnemonicView: View {
    let mnemonic: Mnemonic

    var body: some View {
        VStack(alignment: .leading) {
            if !mnemonic.explanation.isEmpty {
                Text(mnemonic.explanation)
            }
            if let hint = mnemonic.hint, !hint.isEmpty {
                HStack {
                    Image(systemName: "info.bubble.fill")
                    Text(hint)
                }
                .foregroundStyle(.secondary)
                .padding(.vertical, 4)
            }
        }.typography(.callout)
    }
}
