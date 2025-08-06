//
//  LevelUpsTrainingView.swift
//  SerenaApp
//
//  Created by A S on 05/08/2025.
//

import SwiftUI

struct LevelUpsTrainingView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    
    @State private var showConfetti = true
    
    let allKanas: [String]
    @State var kanas: [String]
    let trainingMode: KanaTrainingMode
    @State var level: TrainingLevel = .level1
    @State var progress: Double = 0
    @State var truth: String
    @State var options: [String]
    
    let confettiView = ConfettiView()
    
    init(kanas: [String], trainingMode: KanaTrainingMode) {
        self.allKanas = kanas
        self.kanas = Array(kanas.shuffled().prefix(10))
        self.trainingMode = trainingMode
        
        let options = Array(kanas.shuffled().prefix(3))
        self.options = options
        truth = options.randomElement() ?? ""
    }
    
    var body: some View {
        Group {
            switch level {
            case .level1, .level2:
                ChooseTrainingView(
                    trainingMode: trainingMode,
                    progress: $progress,
                    truth: truth,
                    options: options,
                    trainingLevel: level,
                    onAnwserSubmitted: onAnwserSubmitted
                )
            case .level3, .level4:
                WriteTrainingView(
                    trainingMode: trainingMode,
                    progress: $progress,
                    truth: truth,
                    trainingLevel: level,
                    onAnwserSubmitted: onAnwserSubmitted
                )
            case .completed:
                CompletedView(
                    totalKanasCount: allKanas.count,
                    onTryAgainTapped: {
                        kanas = Array(allKanas.shuffled().prefix(10))
                        level = .level1
                        nextSimpleStep()
                    },
                    onAllInARowTapped: {
                        coordinator.push(.allInARow(allKanas))
                    },
                    onGoBackTapped: {
                        coordinator.popToRoot()
                    }
                )
            }
        }
        .overlay(alignment: .top) { confettiView.ignoresSafeArea().offset(y: -100) }
    }
    
    func nextSimpleStep() {
        switch level {
        case .level1, .level2, .level3:
            options = Array(kanas.shuffled().prefix(3))
            truth = options.randomElement() ?? ""
        case .level4:
            truth = Array(kanas.shuffled().prefix(3)).joined(separator: "")
        case .completed: break
        }
    }
    
    func onAnwserSubmitted(success: Bool) {
        let percent = 1.0 / Double(kanas.count)
        withAnimation {
            progress += success ? percent : -percent
            progress = min(max(progress, 0), 1)
        }
        if progress >= 0.99 {
            goToNextLevel()
        }
        nextSimpleStep()
    }
    
    func goToNextLevel() {
        confettiView.showConfetti()
        progress = 0
        switch level {
        case .level1:
            level = .level2
        case .level2:
            level = .level3
        case .level3:
            level = .level4
        case .level4:
            level = .completed
        case .completed: break
        }
    }
}

struct CompletedView: View {
    let totalKanasCount: Int
    var body: some View {
            VStack {
                Spacer()
                TrainingLevel.completed.prompt.font(.headline)
                    .padding()
                Image(systemName: "party.popper").resizable().frame(width: 80, height: 80)
                    .padding()
                Text("おめでとう").font(.title2)
                Spacer()
                TimelineView(.periodic(from: .now, by: 1)) { context in
                            let date = context.date
                            let seconds = Calendar.current.component(.second, from: date)
                    if seconds % 2 == 0 {
                        Text("└[∵┌] ヾ(-_- )ゞ [┐∵]┘").font(.title2)
                    } else {
                        Text("┌[∵└] ノ( -_-)ノ [┘∵]┐").font(.title2)
                    }
                        }
                HStack {
                    Button("Try again with selection", action: onTryAgainTapped)
                    Button("All in a row", action: onAllInARowTapped)
                }.buttonStyle(.borderedProminent)
                    .padding()
                Button("Go back to selection", action: onGoBackTapped)
                    .buttonStyle(.borderless)
            }
    }
    
    var onTryAgainTapped: () -> Void
    var onAllInARowTapped: () -> Void
    var onGoBackTapped: () -> Void
}

#Preview(body: {
    CompletedView(totalKanasCount: 4, onTryAgainTapped: {}, onAllInARowTapped: {}, onGoBackTapped: {})
})

#Preview {
    LevelUpsTrainingView(kanas: [
        "a", "yo", "ka", "gya","ja","ro","hya","je","po","byo"
    ], trainingMode: .hiragana)
}

struct ProgressView: View {
    @Binding var progress: Double
    @State var barColor: Color = .gray
    
    let barHeight: CGFloat = 30
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(height: barHeight)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                
                GeometryReader { geometry in
                    Capsule()
                        .frame(width: geometry.size.width * progress, height: barHeight)
                        .foregroundStyle(barColor)
                        .cornerRadius(10)
                }
            }
            .frame(height: barHeight)
            Text(progress.formatted(.percent.rounded(increment: 1)))
        }
        .onChange(of: progress, { oldValue, newValue in
            if oldValue < newValue {
                withAnimation(.snappy(duration: 0.2)) {
                    barColor = .green
                } completion: {
                    withAnimation {
                        barColor = .gray
                    }
                }
            } else {
                withAnimation(.snappy(duration: 0.2)) {
                    barColor = .red
                } completion: {
                    withAnimation {
                        barColor = .gray
                    }
                }
            }
        })
        .padding()
    }
}

import SwiftUI

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField

        init(_ parent: CustomTextField) {
            self.parent = parent
        }

        // Prevent Return from dismissing keyboard
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            return false // Returning false prevents keyboard from dismissing
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.borderStyle = .roundedRect
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}


struct WriteTrainingView: View {
    let trainingMode: KanaTrainingMode
    
    @Binding var progress: Double
    let truth: String
    
    let trainingLevel: TrainingLevel
    
    let onAnwserSubmitted: (Bool) -> Void
    
    @State var text: String = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text(trainingLevel.rawValue)
            ProgressView(progress: $progress)
            trainingLevel.prompt
            Text(truth.format(for: trainingMode))
                .font(.system(.largeTitle, design: .rounded))
                .padding()
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 16).stroke()
                })
            Spacer()
            TextEditor(text: $text)
                .onSubmit(onSubmit)
                .padding()
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .focused($isFocused)
                .multilineTextAlignment(.center)
                .textEditorStyle(.plain)
                .font(.largeTitle)
        }.onChange(of: text) { oldValue, newValue in
            newValue.filter(\.isNewline).count > 0 ? onSubmit() : ()
        }.onAppear {
            isFocused = true
        }
    }
    
    func onSubmit() {
        let cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let convertedTruth = truth.format(for: trainingMode)
        let convertedText = cleanedText.format(for: trainingMode)
        
        let isCorrect = convertedTruth == convertedText
        text = ""
        onAnwserSubmitted(isCorrect)
    }
}

struct ChooseTrainingView: View {
    let trainingMode: KanaTrainingMode
    
    @Binding var progress: Double
    let truth: String
    let options: [String]
    
    let trainingLevel: TrainingLevel
    
    let onAnwserSubmitted: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(trainingLevel.rawValue)
            ProgressView(progress: $progress)
            trainingLevel.prompt
            Text(format(truth, for: trainingLevel, kind: .question))
                .font(.system(.largeTitle, design: .rounded))
                .padding()
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 16).stroke()
                })
            Spacer()
            HStack(spacing: 20) {
                ForEach(options.shuffled(), id: \.self) { option in
                    Button(
                        action: { onOptionSelected(option) },
                        label: {
                            Text(format(option, for: trainingLevel, kind: .options))
                                .font(.title2)
                                .padding(.horizontal)
                        })
                    .buttonStyle(.borderedProminent)
                }
            }
            .transaction { transaction in
                transaction.disablesAnimations = true
            }
        }
    }
    
    func onOptionSelected(_ option: String) {
        let isCorrect = option == truth
        onAnwserSubmitted(isCorrect)
    }
    
    func format(_ string: String, for trainingLevel: TrainingLevel, kind: TextKind) -> String {
        switch kind {
        case .question:
            if case .level1 = trainingLevel {
                string.format(for: trainingMode)
            } else {
                string
            }
        case .options:
            if case .level2 = trainingLevel {
                string.format(for: trainingMode)
            } else {
                string
            }
        }
    }
}

enum TextKind {
    case question
    case options
}

enum TrainingLevel: String {
    case level1 = "Level 1"
    case level2 = "Level 2"
    case level3 = "Level 3"
    case level4 = "Level 4"
    case completed
    
    var prompt: Text {
        switch self {
        case .level1:
            Text("Pick the correct **writing** for the kana.")
        case .level2:
            Text("Pick the correct **kana** word for the writing.")
        case .level3:
            Text("**Write** the kana.")
        case .level4:
            Text("**Write** the combinaison of the three kanas.")
        case .completed:
            Text("You finished all the levels !")
        }
    }
}
