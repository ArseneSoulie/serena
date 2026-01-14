import DesignSystem
import FoundationModels
import SwiftUI

enum PickExerciceType {
    case pickRomaji
    case pickKana

    var prompt: LocalizedStringResource {
        switch self {
        case .pickRomaji: .pickTheCorrectWritingForTheKana
        case .pickKana: .pickTheCorrectKanaWordForTheWriting
        }
    }
}

struct PickAnswerPage: View {
    let title: LocalizedStringResource

    let pickingExerciceType: PickExerciceType
    let maxStepsCount: Int
    let kanaPool: [Kana]
    let onLevelCompleted: () -> Void

    @State private var truth: Kana
    @State private var guessingOptions: [Kana]
    @State private var progress: Double = 0
    @State private var truthColor: Color = .primary

    @State private var shakeTrigger: CGFloat = 0
    @State private var showToast = false
    @State private var successAnswerFeedbackTrigger = false
    @State private var failureAnswerFeedbackTrigger = false

    @State private var disableButtons: Bool = false
    @State private var capitalizationColorHint: Color = .secondary

    init(
        title: LocalizedStringResource,
        pickingExerciceType: PickExerciceType,
        kanaPool: [Kana],
        maxStepsCount: Int,
        onLevelCompleted: @escaping () -> Void,
    ) {
        self.title = title
        self.pickingExerciceType = pickingExerciceType
        self.kanaPool = kanaPool
        self.maxStepsCount = maxStepsCount
        self.onLevelCompleted = onLevelCompleted

        let options = Array(kanaPool.shuffled().prefix(3))
        guessingOptions = options
        truth = options.randomElement() ?? .empty
    }

    var formattedTruth: String {
        switch pickingExerciceType {
        case .pickRomaji: truth.kanaValue
        case .pickKana: truth.romajiValue
        }
    }

    func formatGuessingOption(_ option: Kana) -> String {
        switch pickingExerciceType {
        case .pickRomaji: option.romajiValue
        case .pickKana: option.kanaValue
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(pickingExerciceType.prompt)
                        Text(.byConventionHiraganaIsLowercasedAndKatakanaIsUppercased)
                            .foregroundStyle(capitalizationColorHint)
                            .typography(.callout)
                    }
                }

                Section {
                    Text(formattedTruth)
                        .typography(.largeTitle)
                        .padding(.vertical, 20)
                        .foregroundStyle(truthColor)
                        .shake(shakeTrigger)
                        .frame(maxWidth: .infinity)
                }
            }.listStyle(.insetGrouped)
                .overlay(alignment: .bottom) {
                    HStack(spacing: 20) {
                        ForEach(guessingOptions, id: \.self) { option in
                            Button(
                                action: { onOptionSelected(option) },
                                label: { Text(formatGuessingOption(option)).padding(.horizontal) },
                            )
                            .typography(.title)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .buttonStyle(.borderedProminent)
                            .transaction { $0.disablesAnimations = true }
                        }
                    }
                    .padding()
                    .disabled(disableButtons)
                }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                ProgressBarView(progress: $progress)
                    .frame(minWidth: 150)
                    .padding(.leading)
            }
        })
        .toast(isPresented: $showToast, message: .levelUp)
        .sensoryFeedback(.impact, trigger: successAnswerFeedbackTrigger)
        .sensoryFeedback(.error, trigger: failureAnswerFeedbackTrigger)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(title)
    }

    func nextRound() {
        guessingOptions = Array(kanaPool.shuffled().prefix(3))
        truth = guessingOptions.shuffled().first(where: { $0 != truth }) ?? truth
    }

    var answerCompletionPercent: Double {
        1.0 / Double(min(kanaPool.count, maxStepsCount))
    }

    func triggerSensoryFeedback(for isCorrect: Bool) {
        isCorrect ? successAnswerFeedbackTrigger.toggle() : failureAnswerFeedbackTrigger.toggle()
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

    func onOptionSelected(_ option: Kana) {
        let isCorrect = option == truth

        triggerSensoryFeedback(for: isCorrect)

        if !isCorrect {
            triggerWrongAnswer()
        }

        if !isCorrect, option.romajiValue.lowercased() == truth.romajiValue.lowercased() {
            withAnimation(.bouncy(duration: 0.1)) {
                capitalizationColorHint = .orange
            } completion: {
                withAnimation(.linear(duration: 0.3)) {
                    capitalizationColorHint = .secondary
                }
            }
            return
        }

        var nextProgress = isCorrect ? progress + answerCompletionPercent : progress - answerCompletionPercent
        nextProgress = min(max(nextProgress, 0), 1)

        let isLevelCompleted = nextProgress >= 0.99

        if !isLevelCompleted {
            nextRound()
        } else {
            disableButtons = true
            withAnimation {
                showToast = true
            }
        }

        withAnimation {
            progress = nextProgress
        } completion: {
            if isLevelCompleted {
                onLevelCompleted()
                disableButtons = false
            }
        }
    }
}
