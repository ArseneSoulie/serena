import SwiftUI
import FoundationModels

struct AllInARowExercicePage: View {
    let kanas: [Kana]
    
    @State private var progress: Double = 0
    
    @State private var truth: Kana
    @State private var truthColor: Color = .primary
    @State private var shakeTrigger: CGFloat = 0
    
    @State private var inputText: String = ""
    @FocusState private var isFocused: Bool
    
    @Binding var failedKanas: Set<Kana>
    @Binding var remainingKanas: Set<Kana>
    
    let onFinished: () -> Void
    
    init(
        kanas: [Kana],
        failedKanas: Binding<Set<Kana>>,
        remainingKanas: Binding<Set<Kana>>,
        onFinished: @escaping () -> Void
    ) {
        self.kanas = kanas
        truth = remainingKanas.wrappedValue.randomElement() ?? .empty
        _failedKanas = failedKanas
        _remainingKanas = remainingKanas
        self.onFinished = onFinished
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ProgressView(progress: $progress)
                Text(localized("Write the writing of all kanas in a row"))
                Text(truth.kanaValue)
                    .foregroundStyle(truthColor)
                    .modifier(ShakeEffect(animatableData: shakeTrigger))
                    .font(.system(.largeTitle, design: .rounded))
                    .padding()
                    .overlay { RoundedRectangle(cornerRadius: 16).stroke() }
                
                Spacer()
                
                TextEditor(text: $inputText)
                    .onSubmit(onSubmit)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .multilineTextAlignment(.center)
                    .textEditorStyle(.plain)
                    .font(.largeTitle)
                    .focused($isFocused)
                    .padding()
                
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
            Button(localized("Finish"), action: onFinished)
        }
    }
    
    var answerCompletionPercent: Double {
        1.0 / Double(kanas.count)
    }
    
    func onSubmit() {
        let cleanedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines).standardisedRomaji
        let convertedTruth = truth.kanaValue.standardisedRomaji
        
        inputText = ""
        
        let isCorrect = cleanedText == convertedTruth
        
        if isCorrect {
            remainingKanas.remove(truth)
            withAnimation {
                truth = remainingKanas.randomElement() ?? .empty
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
        truth = remainingKanas.randomElement() ?? .empty
    }
}
