
import SwiftUI

enum WriteExerciceType {
    case single
    case groupOfThree
    
    var prompt: String {
        switch self {
        case .single: "Write the kana."
        case .groupOfThree: "Write the combinaison of the three kanas."
        }
    }
}

extension KanaType {
    var autoCapitalization: TextInputAutocapitalization {
        switch self {
        case .hiragana: .never
        case .katakana: .characters
        }
    }
}

struct WriteAnswerPage: View {
    let title: String
    let kanaType: KanaType
    
    let writingExerciceType: WriteExerciceType
    let kanaPool: [String]
    let onLevelCompleted: () -> Void
    
    @State private var truth: String
    @State private var progress: Double = 0
    
    @State var inputText: String = ""
    @FocusState var isFocused: Bool
    
    init(
        title: String,
        kanaType: KanaType,
        writingExerciceType: WriteExerciceType,
        kanaPool: [String],
        onLevelCompleted: @escaping () -> Void,
    ) {
        self.title = title
        self.kanaType = kanaType
        self.writingExerciceType = writingExerciceType
        self.kanaPool = kanaPool
        self.onLevelCompleted = onLevelCompleted

        switch writingExerciceType {
        case .single: truth = kanaPool.randomElement() ?? ""
        case .groupOfThree: truth = kanaPool.shuffled().prefix(3).joined(separator: "")
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
            ProgressView(progress: $progress)
            Text(writingExerciceType.prompt)
            Text(truth.format(kanaType))
                .font(.system(.largeTitle, design: .rounded))
                .padding()
                .overlay { RoundedRectangle(cornerRadius: 16).stroke() }
            
            Spacer()
            
            TextEditor(text: $inputText)
                .onSubmit(onSubmit)
                .autocorrectionDisabled(true)
                .multilineTextAlignment(.center)
                .textInputAutocapitalization(kanaType.autoCapitalization)
                .textEditorStyle(.plain)
                .font(.largeTitle)
                .focused($isFocused)
                .padding()
            
        }
        .onChange(of: inputText) { _, newValue in
            if newValue.filter(\.isNewline).count > 0 { onSubmit() }
        }
        .onAppear { isFocused = true }
    }
    
    func nextRound() {
        isFocused = true
        
        switch writingExerciceType {
        case .single: truth = kanaPool.randomElement() ?? ""
        case .groupOfThree: truth = kanaPool.shuffled().prefix(3).joined(separator: "")
        }
    }
    
    
    var answerCompletionPercent: Double {
        1.0 / Double(kanaPool.count)
    }
    
    func onSubmit() {
        let cleanedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let convertedTruth = truth.format(kanaType)
        let convertedText = cleanedText.format(kanaType)
        
        inputText = ""
        
        let isCorrect = convertedTruth == convertedText
        
        withAnimation {
            progress += isCorrect ? answerCompletionPercent : -answerCompletionPercent
            progress = min(max(progress, 0), 1)
            nextRound()
        } completion: {
            if progress >= 0.99 {
                onLevelCompleted()
            }
        }
    }
}
