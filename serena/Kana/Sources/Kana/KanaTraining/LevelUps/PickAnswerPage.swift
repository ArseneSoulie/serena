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

    @State private var showToast = false

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
        VStack(spacing: 10) {
            ProgressBarView(progress: $progress)
            Text(pickingExerciceType.prompt)
                .padding(.horizontal)
            Text(.byConventionHiraganaIsLowercasedAndKatakanaIsUppercased)
                .foregroundStyle(capitalizationColorHint)
                .padding(.horizontal)
                .padding(.bottom)
                .typography(.callout)

            Text(formattedTruth)
                .typography(.largeTitle)
                .padding()
                .overlay { RoundedRectangle(cornerRadius: 16).stroke() }

            Spacer()

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
                }
            }.disabled(disableButtons)
                .padding()
                .transaction { $0.disablesAnimations = true }
        }
        .navigationTitle(title)
        .toast(isPresented: $showToast, message: .levelUp)
    }

    func nextRound() {
        guessingOptions = Array(kanaPool.shuffled().prefix(3))
        truth = guessingOptions.shuffled().first(where: { $0 != truth }) ?? truth
    }

    var answerCompletionPercent: Double {
        1.0 / Double(min(kanaPool.count, maxStepsCount))
    }

    func onOptionSelected(_ option: Kana) {
        let isCorrect = option == truth

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
