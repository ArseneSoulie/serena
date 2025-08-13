
import SwiftUI
import FoundationModels

enum WriteExerciceType {
    case single
    case groupOfThree
    
    var prompt: String {
        switch self {
        case .single: localized("Write the kana.")
        case .groupOfThree: localized("Write the combinaison of the three kanas.")
        }
    }
}

struct WriteAnswerPage: View {
    let title: String
    
    let writingExerciceType: WriteExerciceType
    let kanaPool: [Kana]
    let onLevelCompleted: () -> Void
    
    @State private var truth: [Kana]
    @State private var progress: Double = 0
    @State private var isLevelCompleted = false
    
    @State var inputText: String = ""
    @FocusState var isFocused: Bool
    
    @State private var showToast = false
    
    init(
        title: String,
        writingExerciceType: WriteExerciceType,
        kanaPool: [Kana],
        onLevelCompleted: @escaping () -> Void,
    ) {
        self.title = title
        self.writingExerciceType = writingExerciceType
        self.kanaPool = kanaPool
        self.onLevelCompleted = onLevelCompleted
        
        switch writingExerciceType {
        case .single: truth = Array(kanaPool.shuffled().prefix(1))
        case .groupOfThree: truth = Array(kanaPool.shuffled().prefix(3))
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ProgressView(progress: $progress)
                Text(writingExerciceType.prompt)
                Text(kanaTruth)
                    .font(.system(.largeTitle, design: .rounded))
                    .padding()
                    .overlay { RoundedRectangle(cornerRadius: 16).stroke() }
                
                Spacer()
                
                ZStack(alignment: .trailing) {
                    TextEditor(text: $inputText)
                        .onSubmit(onSubmit)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.center)
                        .textEditorStyle(.plain)
                        .font(.largeTitle)
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
        .onChange(of: inputText) { _, newValue in
            if newValue.filter(\.isNewline).count > 0 { onSubmit() }
        }
        .onAppear {
            isFocused = true
            isLevelCompleted = false
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toast(isPresented: $showToast, message: localized("Level up !"))
    }
    
    func nextRound() {
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
        1.0 / Double(kanaPool.count)
    }
    
    var kanaTruth: String {
        truth.map(\.kanaValue).joined()
    }
    
    func onSubmit() {
        if isLevelCompleted { return }
        let cleanedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines).standardisedRomaji
        let convertedTruth: String = truth.map(\.kanaValue).joined().standardisedRomaji
        
        inputText = ""
        
        let isCorrect = cleanedText == convertedTruth
        var nextProgress = isCorrect ? progress + answerCompletionPercent : progress - answerCompletionPercent
        nextProgress = min(max(nextProgress, 0), 1)
        
        isLevelCompleted = nextProgress >= 0.99
        
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
