import FoundationModels
import SwiftUI

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

    @State var info: String = ""

    init(
        title: String,
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
        ScrollView {
            VStack(spacing: 10) {
                ProgressBarView(progress: $progress)
                Text(writingExerciceType.prompt)
                VStack {
                    Text(kanaTruth)
                        .foregroundStyle(truthColor)
                        .typography(.largeTitle)
                        .modifier(ShakeEffect(animatableData: shakeTrigger))
                        .padding()
                        .overlay { RoundedRectangle(cornerRadius: 16).stroke() }
                    Text(info)
                }

                ZStack(alignment: .trailing) {
                    TextEditor(text: $inputText)
                        .onSubmit(onSubmit)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.center)
                        .textEditorStyle(.plain)
                        .submitLabel(.send)
                        .typography(.title)
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
        .toolbar {
            Button(localized("Skip"), action: goToNextRound)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toast(isPresented: $showToast, message: localized("Level up !"))
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

    func onSubmit() {
        if !canSubmit { return }
        let (cleanedText, containsInvalidRomaji) = inputText
            .filter { !$0.isWhitespace && !$0.isNewline }
            .standardizedRomajiWithWarningInfo
        let convertedTruth: String = truth.map(\.kanaValue).joined().standardisedRomaji
        let isCorrect = cleanedText == convertedTruth

        inputText = ""
        info = ""

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
            info = localized("This is the right kana but with incorrect writing. Try again!")
        } completion: {
            withAnimation {
                truthColor = .primary
            }
        }
    }
}
