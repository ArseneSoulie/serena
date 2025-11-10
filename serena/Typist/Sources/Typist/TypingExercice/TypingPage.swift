import DesignSystem
import FoundationModels
import SwiftUI

public struct TypingPage: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @StateObject private var typingViewModel: TypingViewModel
    @State private var isFocused: Bool = false

    public init(level: TypingLevel) {
        _typingViewModel = StateObject(wrappedValue: TypingViewModel(level: level))
    }

    public var body: some View {
        ZStack {
            AnimatedBackground(difficultyScale: typingViewModel.difficultyScale)
                .ignoresSafeArea()

            VStack(spacing: 10) {
                if typingViewModel.isPlaying {
                    TopBars(
                        health: typingViewModel.health,
                        comboCount: typingViewModel.comboCount,
                        score: typingViewModel.score,
                    )
                }

                if typingViewModel.isPlaying {
                    Playfield(
                        textsToType: typingViewModel.textsToType,
                        scorePopups: typingViewModel.scorePopups,
                        showLevelUp: typingViewModel.showLevelUp,
                        inputText: typingViewModel.inputText,
                    )
                    .modifier(ShakeEffect(
                        amount: reduceMotion ? 0 : 2,
                        shakesPerUnit: 5,
                        animatableData: typingViewModel.shakeTrigger,
                    ))
                    .animation(.easeOut(duration: 0.4), value: typingViewModel.shakeTrigger)

                } else {
                    FinishCard(
                        score: typingViewModel.score,
                        bestCombo: typingViewModel.bestCombo,
                        isHighScore: typingViewModel.isHighScore,
                        onRestart: {
                            typingViewModel.restartGame()
                            isFocused = true
                        },
                    )
                }

                if typingViewModel.isPlaying {
                    inputBar
                }
            }
        }
        .onAppear {
            typingViewModel.startGame()
            Task {
                isFocused = true
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Toggle("Auto-submit", isOn: $typingViewModel.autoSubmitEnabled)
            }
        }
        .onDisappear {
            typingViewModel.endGame()
        }
        .navigationTitle("Typing")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var inputBar: some View {
        KanaTextFieldView(
            text: $typingViewModel.inputText,
            isFirstResponder: $isFocused,
            languageCode: "ja",
            placeholder: "日本語で入力してください",
            onSubmit: { typingViewModel.onSubmit() },
        )
        .padding(.horizontal, 12)
        .frame(minHeight: 36, maxHeight: 44)
        .background(.ultraThinMaterial, in: Capsule())
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

// MARK: - Subviews

private struct TopBars: View {
    let health: Int
    let comboCount: Int
    let score: Int

    private var comboMultiplier: Double { 1.0 + Double(comboCount) * 0.1 }
    private let maxHealth = 3

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                heartsView
                Spacer()
                comboView
            }
            .padding(.horizontal)

            HStack {
                Text("Points: \(score)")
                Spacer()
            }
            .padding(.horizontal)
        }
        .font(.callout)
    }

    private var heartsView: some View {
        HStack(spacing: 6) {
            ForEach(1 ... maxHealth, id: \.self) { index in
                Image(systemName: index <= health ? "heart.fill" : "heart")
                    .foregroundStyle(index <= health ? .red : .secondary)
                    .scaleEffect(index <= health ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: health)
            }
        }
    }

    private var comboView: some View {
        Group {
            if comboCount > 0 {
                Text("Combo \(comboCount) • x\(comboMultiplier, specifier: "%.1f")")
                    .foregroundStyle(.orange)
                    .transition(.opacity.animation(.easeInOut))
            }
        }
    }
}

private struct Playfield: View {
    let textsToType: [TextToType]
    let scorePopups: [ScorePopup]
    let showLevelUp: Bool
    let inputText: String

    var body: some View {
        ZStack(alignment: .topTrailing) {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    ForEach(textsToType) { textToType in
                        TextToMatchView(
                            data: .init(
                                reading: textToType.word.reading,
                                writing: textToType.word.writing,
                                textToMatch: inputText,
                            ),
                        )
                        .position(
                            x: textToType.x * geometry.size.width,
                            y: textToType.y * geometry.size.height,
                        )
                    }

                    ForEach(scorePopups) { popup in
                        Text(popup.text)
                            .font(.headline)
                            .foregroundStyle(.green)
                            .opacity(popup.opacity)
                            .position(
                                x: popup.x * geometry.size.width,
                                y: popup.y * geometry.size.height + popup.offsetY,
                            )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            if showLevelUp {
                Text("Level Up!")
                    .font(.headline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.ultraThinMaterial, in: Capsule())
                    .overlay { Capsule().stroke(.orange, lineWidth: 2) }
                    .shadow(radius: 6)
                    .transition(.opacity.combined(with: .scale))
                    .padding([.top, .trailing], 12)
            }
        }
    }
}

private struct FinishCard: View {
    let score: Int
    let bestCombo: Int
    let isHighScore: Bool
    let onRestart: () -> Void

    private var bestComboMultiplier: Double { 1.0 + Double(bestCombo) * 0.1 }

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 14) {
                Text("Finished")
                    .typography(.title2)
                VStack(spacing: 6) {
                    Text("Total score")
                        .foregroundStyle(.secondary)
                    Text("\(score)")
                        .typography(.title)
                        .font(.largeTitle)
                }
                if isHighScore {
                    Text("New high score !")
                }
                if bestCombo > 0 {
                    Text("Best combo: \(bestCombo) • x\(bestComboMultiplier, specifier: "%.1f")")
                        .foregroundStyle(.orange)
                }
                Button(action: onRestart) {
                    Text("Play again")
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial, in: Capsule())
                }
            }
            .padding(20)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
            .shadow(radius: 10)
            Spacer()
        }
        .padding()
    }
}

private struct AnimatedBackground: View {
    let difficultyScale: Double
    private let maxDifficultyForGradient: Double = 3

    var body: some View {
        let t = min(difficultyScale / maxDifficultyForGradient, 1.0)
        let start = Color(hue: 210 / 360, saturation: 0.35 + 0.10 * t, brightness: 1)
        let end = Color(hue: (260 - 230 * t) / 360, saturation: 0.50 + 0.35 * t, brightness: 0.95 + 0.05 * t)

        return LinearGradient(colors: [start, end], startPoint: .topLeading, endPoint: .bottomTrailing)
            .animation(.easeInOut(duration: 0.6), value: difficultyScale)
    }
}

// MARK: - Helper Views and Modifiers

private struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size _: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(
            translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0,
        ))
    }
}
