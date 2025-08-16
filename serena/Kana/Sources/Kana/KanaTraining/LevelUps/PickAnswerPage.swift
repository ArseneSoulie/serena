import FoundationModels
import SwiftUI

enum PickExerciceType {
    case pickRomaji
    case pickKana

    var prompt: String {
        switch self {
        case .pickRomaji: localized("Pick the correct writing for the kana.")
        case .pickKana: localized("Pick the correct kana word for the writing.")
        }
    }
}

struct PickAnswerPage: View {
    let title: String

    let pickingExerciceType: PickExerciceType

    let kanaPool: [Kana]
    let onLevelCompleted: () -> Void

    @State private var truth: Kana
    @State private var guessingOptions: [Kana]
    @State private var progress: Double = 0

    @State private var showToast = false

    @State private var disableButtons: Bool = false

    init(
        title: String,
        pickingExerciceType: PickExerciceType,
        kanaPool: [Kana],
        onLevelCompleted: @escaping () -> Void,
    ) {
        self.title = title
        self.pickingExerciceType = pickingExerciceType
        self.kanaPool = kanaPool
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
        VStack(spacing: 20) {
            ProgressView(progress: $progress)
            Text(pickingExerciceType.prompt)

            Text(formattedTruth)
                .typography(.largeTitle)
                .padding()
                .overlay { RoundedRectangle(cornerRadius: 16).stroke() }

            Spacer()

            HStack(spacing: 20) {
                ForEach(guessingOptions.shuffled(), id: \.self) { option in
                    Button(
                        action: { onOptionSelected(option) },
                        label: { Text(formatGuessingOption(option)).padding(.horizontal) },
                    )
                    .typography(.title)
                    .buttonStyle(.borderedProminent)
                }
            }.disabled(disableButtons)
                .padding()
                .transaction { $0.disablesAnimations = true }
        }
        .navigationTitle(title)
        .toast(isPresented: $showToast, message: localized("Level up !"))
    }

    func nextRound() {
        guessingOptions = Array(kanaPool.shuffled().prefix(3))
        truth = guessingOptions.shuffled().first(where: { $0 != truth }) ?? truth
    }

    var answerCompletionPercent: Double {
        1.0 / Double(kanaPool.count)
    }

    func onOptionSelected(_ option: Kana) {
        let isCorrect = option == truth
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
