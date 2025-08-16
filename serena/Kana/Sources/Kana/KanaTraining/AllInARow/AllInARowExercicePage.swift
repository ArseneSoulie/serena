import FoundationModels
import SwiftUI

struct AllInARowExercicePage: View {
    let kanas: [Kana]

    @State private var progress: Double = 0

    @State private var truth: Kana
    @State private var truthColor: Color = .primary
    @State private var shakeTrigger: CGFloat = 0

    @State private var inputText: String = ""
    @FocusState private var isFocused: Bool

    @Binding var failedKanas: Set<Kana>
    @Binding var remainingKanas: Set<Kana>

    @State var info: String = ""

    let onFinished: () -> Void

    init(
        kanas: [Kana],
        failedKanas: Binding<Set<Kana>>,
        remainingKanas: Binding<Set<Kana>>,
        onFinished: @escaping () -> Void,
    ) {
        self.kanas = kanas
        truth = remainingKanas.wrappedValue.randomElement() ?? .empty
        _failedKanas = failedKanas
        _remainingKanas = remainingKanas
        self.onFinished = onFinished
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ProgressView(progress: $progress)
                Text(localized("Write the writing of all kanas in a row"))

                VStack {
                    Text(truth.kanaValue)
                        .foregroundStyle(truthColor)
                        .modifier(ShakeEffect(animatableData: shakeTrigger))
                        .typography(.largeTitle)
                        .padding()
                        .overlay { RoundedRectangle(cornerRadius: 16).stroke() }
                    Text(info)
                }

                Spacer()

                ZStack(alignment: .trailing) {
                    TextEditor(text: $inputText)
                        .onSubmit(onSubmit)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.center)
                        .textEditorStyle(.plain)
                        .typography(.largeTitle)
                        .focused($isFocused)

                    Button(action: onSubmit) {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                    }
                }
                .overlay { RoundedRectangle(cornerRadius: 16).stroke() }
                .padding()
            }
        }
        .navigationTitle(localized("All in a row"))
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: inputText) { _, newValue in
            if newValue.filter(\.isNewline).count > 0 { onSubmit() }
        }
        .onAppear { isFocused = true }
        .toolbar {
            Button(localized("Skip"), action: onSkip)
            Button(localized("Finish"), action: onFinished)
        }
    }

    var answerCompletionPercent: Double {
        1.0 / Double(kanas.count)
    }

    func onSubmit() {
        let (cleanedText, containsInvalidRomaji) = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
            .standardizedRomajiWithWarningInfo
        let convertedTruth = truth.kanaValue.standardisedRomaji
        let isCorrect = cleanedText == convertedTruth

        info = ""

        if !isCorrect {
            failedKanas.insert(truth)
            withAnimation(.default) {
                truthColor = .red
                shakeTrigger += 1
            } completion: {
                withAnimation {
                    truthColor = .primary
                }
            }
        } else if containsInvalidRomaji {
            withAnimation(.default) {
                truthColor = .orange
                shakeTrigger += 1
                info = "This is the right kana but with incorrect writing. Try again!"
            } completion: {
                withAnimation {
                    truthColor = .primary
                }
            }
        } else {
            remainingKanas.remove(truth)
            withAnimation {
                nextRandomKana()
                progress += answerCompletionPercent
                if progress >= 0.99 {
                    onFinished()
                }
            }
        }

        inputText = ""
    }

    func onSkip() {
        nextRandomKana()
    }

    func nextRandomKana() {
        truth = remainingKanas.filter { truth != $0 }.randomElement() ?? remainingKanas.first ?? .empty
    }
}

#Preview {
    AllInARowExercicePage(
        kanas: [
            .hiragana(value: "a"),
            .hiragana(value: "i"),
            .hiragana(value: "u"),
            .hiragana(value: "e"),
            .hiragana(value: "o"),
            .hiragana(value: "ka"),
            .hiragana(value: "ki"),
            .hiragana(value: "ku"),
        ],
        failedKanas: .constant([.hiragana(value: "ka")]),
        remainingKanas: .constant([]),
        onFinished: {},
    )
}
