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
            AnimatedBackground(currentDifficulty: typingViewModel.currentDifficulty, livesCount: typingViewModel.health)

            VStack(spacing: 10) {
                if typingViewModel.isPlaying {
                    TopBars(
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
                Toggle(.autoSubmit, isOn: $typingViewModel.autoSubmitEnabled)
            }
        }
        .onDisappear {
            typingViewModel.endGame()
        }
        .navigationTitle(.typing)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var inputBar: some View {
        KanaTextFieldView(
            text: $typingViewModel.inputText,
            isFirstResponder: $isFocused,
            languageCode: "ja",
            placeholder: .inputTheFallingText,
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
    let comboCount: Int
    let score: Int

    private var comboMultiplier: Double { 1.0 + Double(comboCount) * 0.1 }
    private let maxHealth = 3

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                comboView
            }
            .padding(.horizontal)

            HStack {
                Text(.points(score))
                Spacer()
            }
            .padding(.horizontal)
        }
        .font(.callout)
    }

    private var comboView: some View {
        Group {
            if comboCount > 0 {
                Text(.comboX(comboCount, Float(comboMultiplier)))
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
                Text(.levelUp)
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
                Text(.finished)
                    .typography(.title2)
                VStack(spacing: 6) {
                    Text(.totalScore)
                        .foregroundStyle(.secondary)
                    Text("\(score)")
                        .typography(.title)
                        .font(.largeTitle)
                }
                if isHighScore {
                    Text(.newHighScore)
                }
                if bestCombo > 0 {
                    Text(.bestComboX(bestCombo, Float(bestComboMultiplier)))
                        .foregroundStyle(.orange)
                }
                Button(action: onRestart) {
                    Text(.playAgain)
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
    let currentDifficulty: Int
    let livesCount: Int

    private let dayCycleColors: [Color] = [
        Color(hue: 0.58, saturation: 0.25, brightness: 1.0),
        Color(hue: 0.58, saturation: 0.50, brightness: 0.9),
        Color(hue: 0.56, saturation: 1.0, brightness: 0.75),
        Color(hue: 0.58, saturation: 0.35, brightness: 0.8),
        Color(hue: 0.05, saturation: 0.70, brightness: 0.85),
        Color(hue: 0.85, saturation: 0.60, brightness: 0.70),
        Color(hue: 0.70, saturation: 0.80, brightness: 0.20),
        Color(hue: 0.70, saturation: 0.90, brightness: 0.15),
        Color(hue: 0.95, saturation: 0.50, brightness: 0.50),
    ]

    var body: some View {
        let gradientTop = dayCycleColors[currentDifficulty % dayCycleColors.count]
        let gradientBottom = dayCycleColors[(currentDifficulty + 1) % dayCycleColors.count]

        return ZStack(alignment: .bottom) {
            Color(.grass)
                .ignoresSafeArea(.all, edges: .bottom)

            LinearGradient(colors: [gradientTop, gradientBottom], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all, edges: .top)

            Image(.castle)
                .resizable()
                .scaledToFit()
                .background {
                    GeometryReader { geo in
                        if livesCount >= 1 {
                            HStack {
                                ForEach(Range(1 ... livesCount), id: \.self) { _ in
                                    Image(.flag)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: geo.size.height * 0.18)
                                        .transition(.move(edge: .bottom))
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .offset(x: geo.size.width * 0.175, y: geo.size.height * 0.15)
                        }
                    }
                }
        }
    }
}

#Preview {
    @Previewable @State var lives = 3
    AnimatedBackground(currentDifficulty: 10, livesCount: lives)
    Button("aa", action: {
        withAnimation {
            lives -= 1
        }
    })
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
