import DesignSystem
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

    @State var failedKanas: Set<Kana> = []
    @State var remainingKanas: Set<Kana>

    @State var handwrittenFont: CustomFontFamily = .yujiBoku
    @State var info: String = ""
    @State var showAnswer: Bool = false

    let handwrittenFontFamilies: [CustomFontFamily] = [.hachiMaruPop, .yujiBoku, .yujiMai, .yujiSyuku]

    let onFinishedExercice: (AllInARowResult) -> Void

    init(
        kanas: [Kana],
        onFinishedExercice: @escaping (AllInARowResult) -> Void,
    ) {
        self.kanas = kanas
        remainingKanas = Set(kanas)
        truth = kanas.randomElement() ?? .empty
        self.onFinishedExercice = onFinishedExercice
        randomizeFont()
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ProgressBarView(progress: $progress)
                Text(localized("Write the writing of all kanas in a row"))

                VStack {
                    ZStack(alignment: .bottom) {
                        Text(truth.kanaValue)
                            .foregroundStyle(truthColor)
                            .modifier(ShakeEffect(animatableData: shakeTrigger))
                            .typography(.largeTitle, fontFamily: handwrittenFont)
                            .padding()
                        if showAnswer {
                            Text(truth.romajiValue)
                                .typography(.caption)
                        }
                    }
                    .padding(.bottom, 8)
                    .overlay { RoundedRectangle(cornerRadius: 16).stroke() }
                    .overlay(alignment: .bottomTrailing) {
                        Button(
                            action: randomizeFont,
                            label: { Image(systemName: "arrow.trianglehead.2.clockwise") },
                        )
                        .padding(8)
                    }
                    Text(info)
                }

                ZStack(alignment: .trailing) {
                    TextEditor(text: $inputText)
                        .onSubmit(onSubmit)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.center)
                        .textEditorStyle(.plain)
                        .submitLabel(.send)
                        .typography(.title)
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
                if failedKanas.contains(truth) {
                    Button(localized("Reveal answer"), action: { showAnswer.toggle() })
                }
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
            Button(localized("Finish"), action: finishExercice)
        }
        .animation(.default, value: failedKanas)
        .animation(.default, value: showAnswer)
    }

    var answerCompletionPercent: Double {
        1.0 / Double(kanas.count)
    }

    func finishExercice() {
        onFinishedExercice(
            .init(
                succeededKanas: kanas.filter { !remainingKanas.contains($0) }.filter { !failedKanas.contains($0) },
                skippedKanas: Array(remainingKanas),
                failedKanas: Array(failedKanas),
            ),
        )
    }

    func onSubmit() {
        let (cleanedText, containsInvalidRomaji) = inputText
            .filter { !$0.isWhitespace && !$0.isNewline }
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
                info = localized("This is the right kana but with incorrect writing. Try again!")
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
                    finishExercice()
                }
            }
        }

        inputText = ""
    }

    func onSkip() {
        nextRandomKana()
    }

    func nextRandomKana() {
        showAnswer = false
        randomizeFont()
        truth = remainingKanas.filter { truth != $0 }.randomElement() ?? remainingKanas.first ?? .empty
    }

    func randomizeFont() {
        handwrittenFont = handwrittenFontFamilies.filter { $0 != handwrittenFont }.randomElement() ?? .mPlus
    }
}

#Preview {
    NavigationView {
        AllInARowExercicePage(
            kanas: [
                .hiragana(value: "a"),
                .hiragana(value: "i"),
                .hiragana(value: "u"),
                .hiragana(value: "tsu"),
                .hiragana(value: "o"),
                .hiragana(value: "ka"),
                .hiragana(value: "ki"),
                .hiragana(value: "ku"),
            ],
            onFinishedExercice: { _ in },
        )
    }
}
