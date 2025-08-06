import SwiftUI

struct AllInARowExercicePage: View {
    let kanas: [String]
    let kanaType: KanaType
    
    @State private var progress: Double = 0
    
    @State private var truth: String
    @State private var truthColor: Color = .primary
    @State private var shakeTrigger: CGFloat = 0
    
    @State private var inputText: String = ""
    @FocusState private var isFocused: Bool
    
    @Binding var failedKanas: Set<String>
    @Binding var remainingKanas: Set<String>
    
    let onFinished: () -> Void
    
    init(
        kanas: [String],
        kanaType: KanaType,
        failedKanas: Binding<Set<String>>,
        remainingKanas: Binding<Set<String>>,
        onFinished: @escaping () -> Void
    ) {
        self.kanas = kanas
        self.kanaType = kanaType
        truth = remainingKanas.wrappedValue.randomElement() ?? ""
        _failedKanas = failedKanas
        _remainingKanas = remainingKanas
        self.onFinished = onFinished
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("All in a row")
            ProgressView(progress: $progress)
            Text("Write the writing of all kanas in a row")
            Text(truth.format(kanaType))
                .foregroundStyle(truthColor)
                .modifier(ShakeEffect(animatableData: shakeTrigger))
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
        .toolbar {
            Button("Skip", action: onSkip)
            Button("Finish", action: onFinished)
        }
    }
    
    var answerCompletionPercent: Double {
        1.0 / Double(kanas.count)
    }
    
    func onSubmit() {
        let cleanedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let convertedTruth = truth.format(kanaType)
        let convertedText = cleanedText.format(kanaType)
        
        inputText = ""
        
        let isCorrect = convertedTruth == convertedText
        
        if isCorrect {
            remainingKanas.remove(truth)
            withAnimation {
                truth = remainingKanas.randomElement() ?? ""
                progress += answerCompletionPercent
                if progress >= 0.99 {
                    onFinished()
                }
            }
        } else {
            failedKanas.insert(truth)
            withAnimation(.default) {
                truthColor = .red
                shakeTrigger += 1
            } completion: {
                withAnimation {
                    truthColor = .primary
                }
            }
        }
    }
    
    func onSkip() {
        truth = remainingKanas.randomElement() ?? ""
    }
}
