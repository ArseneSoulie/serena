import SwiftUI

enum PickExerciceType {
    case pickRomaji
    case pickKana
    
    var prompt: String {
        switch self {
        case .pickRomaji: "Pick the correct writing for the kana."
        case .pickKana: "Pick the correct kana word for the writing."
        }
    }
}

struct PickAnswerPage: View {
    let title: String
    
    let pickingExerciceType: PickExerciceType
    let kanaType: KanaType
    
    let kanaPool: [String]
    let onLevelCompleted: () -> Void
    
    @State private var truth: String
    @State private var guessingOptions: [String]
    @State private var progress: Double = 0
    
    @State private var showToast = false
    
    init(
        title: String,
        pickingExerciceType: PickExerciceType,
        kanaType: KanaType,
        kanaPool: [String],
        onLevelCompleted: @escaping () -> Void
    ) {
        self.title = title
        self.pickingExerciceType = pickingExerciceType
        self.kanaType = kanaType
        self.kanaPool = kanaPool
        self.onLevelCompleted = onLevelCompleted
        let options = Array(kanaPool.shuffled().prefix(3))
        guessingOptions = options
        truth = options.randomElement() ?? ""
    }
    
    
    var formattedTruth: String {
        switch pickingExerciceType {
        case .pickRomaji: truth.format(kanaType)
        case .pickKana: truth.formatAsRomaji(kanaType)
        }
    }
    
    func formatGuessingOption(_ option: String) -> String {
        switch pickingExerciceType {
        case .pickRomaji: option.formatAsRomaji(kanaType)
        case .pickKana: option.format(kanaType)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
            ProgressView(progress: $progress)
            Text(pickingExerciceType.prompt)
            Text(formattedTruth)
                .font(.system(.largeTitle, design: .rounded))
                .padding()
                .overlay { RoundedRectangle(cornerRadius: 16).stroke() }
            
            Spacer()
            
            HStack(spacing: 20) {
                ForEach(guessingOptions.shuffled(), id: \.self) { option in
                    Button(
                        action: { onOptionSelected(option) },
                        label: { Text(formatGuessingOption(option)).padding(.horizontal)}
                    )
                    .font(.title2)
                    .buttonStyle(.borderedProminent)
                }
            }
            .transaction { $0.disablesAnimations = true}
        }
        .toast(isPresented: $showToast, message: "Level up !")
    }
    
    func nextRound() {
        guessingOptions = Array(kanaPool.shuffled().prefix(3))
        truth = guessingOptions.randomElement() ?? ""
    }
    
    var answerCompletionPercent: Double {
        1.0 / Double(kanaPool.count)
    }
    
    func onOptionSelected(_ option: String) {
        let isCorrect = option == truth
        var nextProgress = isCorrect ? progress + answerCompletionPercent : progress - answerCompletionPercent
        nextProgress = min(max(nextProgress, 0), 1)
        
        let isLevelCompleted = nextProgress >= 0.99
        
        if !isLevelCompleted {
            nextRound()
        } else {
            withAnimation {
                showToast = true
            }
        }
        
        withAnimation {
            progress = nextProgress
        } completion: {
            if isLevelCompleted {
                onLevelCompleted()
            }
        }
    }
}
