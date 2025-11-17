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
    @State var info: LocalizedStringResource?
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
        VStack {
            List {
                Section {
                    Text(.allInARow)
                        .typography(.title2)
                }
                .listRowBackground(Color.clear)
                .listRowSpacing(0)
                .listSectionSpacing(0)

                Section {
                    Text(.writeTheWritingOfAllKanasInARow)
                    Button(action: randomizeFont) {
                        VStack {
                            Text(truth.kanaValue)
                                .foregroundStyle(truthColor)
                                .shake(shakeTrigger)
                                .typography(.largeTitle, fontFamily: handwrittenFont)

                            if showAnswer {
                                Text(truth.romajiValue)
                                    .padding(.bottom)
                            }

                            if failedKanas.contains(truth) {
                                Button(.revealAnswer, action: onRevealAnswer)
                                    .buttonStyle(.borderless)
                            } else if let info {
                                Text(info)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .overlay(alignment: .topTrailing) {
                            Button("", systemImage: "chevron.forward.2", action: onSkip)
                                .buttonStyle(.borderless)
                        }
                    }.buttonStyle(.plain)
                }
            }
            .listStyle(.insetGrouped)
        }
        .overlay(alignment: .bottom) {
            ZStack(alignment: .trailing) {
                TextEditor(text: $inputText)
                    .onSubmit(onSubmit)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .multilineTextAlignment(.center)
                    .textEditorStyle(.plain)
                    .submitLabel(.send)
                    .typography(.title2)
                    .focused($isFocused)

                Button(action: onSubmit) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .background {
                Color(uiColor: .secondarySystemGroupedBackground)
                    .cornerRadius(.round)
                    .border(style: .quaternary, cornerRadius: .round)
            }
            .padding()
        }
        .onChange(of: inputText) { _, newValue in
            if newValue.filter(\.isNewline).count > 0 { onSubmit() }
        }
        .onAppear { isFocused = true }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ProgressBarView(progress: $progress).frame(minWidth: 150).padding(.leading)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(.finish, action: finishExercice)
            }
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

        withAnimation {
            info = nil
        }

        if !isCorrect {
            withAnimation(.default) {
                failedKanas.insert(truth)
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
                info = .thisIsTheRightKanaButWithIncorrectWritingTryAgain
            } completion: {
                withAnimation {
                    truthColor = .primary
                }
            }
        } else {
            withAnimation {
                remainingKanas.remove(truth)
                nextRandomKana()
                progress += answerCompletionPercent
                if progress >= 0.99 {
                    finishExercice()
                }
            }
        }

        inputText = ""
    }

    func onRevealAnswer() {
        withAnimation {
            showAnswer.toggle()
        }
    }

    func onSkip() {
        nextRandomKana()
    }

    func nextRandomKana() {
        withAnimation {
            showAnswer = false
            randomizeFont()
            truth = remainingKanas.filter { truth != $0 }.randomElement() ?? remainingKanas.first ?? .empty
        }
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
