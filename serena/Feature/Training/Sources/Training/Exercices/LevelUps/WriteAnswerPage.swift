import DesignSystem
import FoundationModels
import SwiftUI

enum WriteExerciceType {
    case single
    case groupOfThree

    var prompt: LocalizedStringResource {
        switch self {
        case .single: .writeTheKana
        case .groupOfThree: .writeTheCombinaisonOfTheThreeKanas
        }
    }

    var subtitle: LocalizedStringResource {
        switch self {
        case .single: .byConventionHiraganaIsLowercasedAndKatakanaIsUppercased
        case .groupOfThree: .writeTheCombinaisonSubtitle
        }
    }
}

struct WriteAnswerPage: View {
    let title: LocalizedStringResource

    let writingExerciceType: WriteExerciceType
    let kanaPool: [Kana]
    let maxStepsCount: Int
    let onLevelCompleted: () -> Void

    @State private var truth: [Kana]
    @State private var progress: Double = 0
    @State private var isLevelCompleted = false
    @State private var truthColor: Color = .primary
    @State private var shakeTrigger: CGFloat = 0

    @State var inputText: String = ""
    @FocusState var isFocused: Bool

    @State private var showToast = false
    @State private var successAnswerFeedbackTrigger = false
    @State private var failureAnswerFeedbackTrigger = false

    @State var info: LocalizedStringResource?

    init(
        title: LocalizedStringResource,
        writingExerciceType: WriteExerciceType,
        kanaPool: [Kana],
        maxStepsCount: Int,
        onLevelCompleted: @escaping () -> Void,
    ) {
        self.title = title
        self.writingExerciceType = writingExerciceType
        self.kanaPool = kanaPool
        self.maxStepsCount = maxStepsCount
        self.onLevelCompleted = onLevelCompleted

        switch writingExerciceType {
        case .single: truth = Array(kanaPool.shuffled().prefix(1))
        case .groupOfThree: truth = Array(kanaPool.shuffled().prefix(3))
        }
    }

    var body: some View {
        VStack {
            List {
                Section {
                    VStack(spacing: 8) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(writingExerciceType.prompt)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Text(writingExerciceType.subtitle)
                                .lineLimit(3)
                                .minimumScaleFactor(0.5)
                                .foregroundStyle(.secondary)
                                .typography(.callout)
                        }
                        HStack {
                            Button(.skip, action: goToNextRound)
                                .buttonStyle(.borderless)
                                .hidden()
                            Spacer()
                            Text(kanaTruth)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .foregroundStyle(truthColor)
                                .typography(.largeTitle)
                                .shake(shakeTrigger)
                            Spacer()
                            Button(.skip, action: goToNextRound)
                                .buttonStyle(.borderless)
                        }

                        if let info {
                            Text(info)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                Spacer().frame(height: 50)
                    .listRowBackground(Color.clear)
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
                        .padding(.all, 12)
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
        .onAppear {
            isFocused = true
            isLevelCompleted = false
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ProgressBarView(progress: $progress)
                    .frame(minWidth: 150)
                    .padding(.leading)
            }
        }
        .toast(isPresented: $showToast, message: .levelUp)
        .sensoryFeedback(.impact, trigger: successAnswerFeedbackTrigger)
        .sensoryFeedback(.error, trigger: failureAnswerFeedbackTrigger)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(title)
    }

    func goToNextRound() {
        isFocused = true

        switch writingExerciceType {
        case .single:
            let nextTruth = kanaPool.filter { !truth.contains($0) }.randomElement() ?? kanaPool.first ?? .empty
            truth = [nextTruth]
        case .groupOfThree:
            truth = Array(kanaPool.shuffled().prefix(3))
        }
    }

    var answerCompletionPercent: Double {
        1.0 / Double(min(kanaPool.count, maxStepsCount))
    }

    var kanaTruth: String {
        truth.map(\.kanaValue).joined()
    }

    @State var canSubmit: Bool = true

    func triggerSensoryFeedback(for isCorrect: Bool) {
        isCorrect ? successAnswerFeedbackTrigger.toggle() : failureAnswerFeedbackTrigger.toggle()
    }

    func onSubmit() {
        if !canSubmit { return }
        let (cleanedText, containsInvalidRomaji) = inputText
            .filter { !$0.isWhitespace && !$0.isNewline }
            .standardizedRomajiWithWarningInfo
        let convertedTruth: String = truth.map(\.kanaValue).joined().standardisedRomaji
        let isCorrect = cleanedText == convertedTruth

        inputText = ""
        info = nil

        triggerSensoryFeedback(for: isCorrect)

        if !isCorrect {
            triggerWrongAnswer()
            withAnimation {
                progress = max(progress - answerCompletionPercent, 0)
            }
        } else if containsInvalidRomaji {
            triggerInvalidCharacters()
        } else {
            withAnimation {
                progress = min(progress + answerCompletionPercent, 1)
            }
            if progress >= 0.99 {
                completeLevel()
            } else {
                goToNextRound()
            }
        }
    }

    func completeLevel() {
        canSubmit = false

        withAnimation {
            showToast = true
        } completion: {
            canSubmit = true
            progress = 0
            onLevelCompleted()
        }
    }

    func triggerWrongAnswer() {
        withAnimation(.default) {
            truthColor = .red
            shakeTrigger += 1
        } completion: {
            withAnimation {
                truthColor = .primary
            }
        }
    }

    func triggerInvalidCharacters() {
        withAnimation(.default) {
            truthColor = .orange
            shakeTrigger += 1
            info = .thisIsTheRightKanaButWithIncorrectWritingTryAgain
        } completion: {
            withAnimation {
                truthColor = .primary
            }
        }
    }
}

#Preview {
    NavigationView {
        WriteAnswerPage(
            title: .writeTheKana,
            writingExerciceType: .single,
            kanaPool: [.hiragana(value: "あ")],
            maxStepsCount: 3,
            onLevelCompleted: {},
        )
    }
}
