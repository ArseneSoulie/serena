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
            AnimatedBackground(
                currentDifficulty: typingViewModel.currentDifficulty,
                livesCount: typingViewModel.health,
                castleResource: typingViewModel.castleImageResource,
                flagOffset: typingViewModel.flagOffset,
            )

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
                    VStack(alignment: .leading) {
                        Text(.inputTheFallingText)
                            .typography(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial, in: Capsule())
                            .padding(.horizontal)
                        inputBar
                    }
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

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(.points(score))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                    .background(.thickMaterial, in: Capsule())
                    .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 3)
                Spacer()
                if comboCount > 0 {
                    Text(.comboX(comboCount, Float(comboMultiplier)))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        .background(.thickMaterial, in: Capsule())
                        .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 3)
                        .transition(.opacity.animation(.easeInOut))
                }
            }
            .padding(.horizontal)
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
                            .typography(.headline)
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
                    .typography(.headline)
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
    let castleResource: ImageResource
    let flagOffset: CGPoint

    private let dayCycleColors: [Color] = [
        Color(._Sky.dawn),
        Color(._Sky.morning),
        Color(._Sky.noon),
        Color(._Sky.afternoon),
        Color(._Sky.evening),
        Color(._Sky.night),
        Color(._Sky.midnight),
        Color(._Sky.aftermidnight),
    ]

    var body: some View {
        let gradientTop = dayCycleColors[currentDifficulty % dayCycleColors.count]
        let gradientBottom = dayCycleColors[(currentDifficulty + 1) % dayCycleColors.count]

        return ZStack(alignment: .bottom) {
            Color(._Typing.grass)
                .ignoresSafeArea(.all, edges: .bottom)

            LinearGradient(colors: [gradientTop, gradientBottom], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all, edges: .top)

            Image(castleResource)
                .resizable()
                .scaledToFit()
                .background {
                    GeometryReader { geo in
                        if livesCount >= 1 {
                            HStack {
                                ForEach(Range(1 ... livesCount), id: \.self) { _ in
                                    Image(._Typing.flag)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: geo.size.height * 0.18)
                                        .transition(.move(edge: .bottom))
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .offset(x: geo.size.width * flagOffset.x, y: geo.size.height * flagOffset.y)
                        }
                    }
                }
        }
    }
}

#Preview {
    @Previewable @State var lives = 3
    AnimatedBackground(
        currentDifficulty: 10,
        livesCount: lives,
        castleResource: ._Typing.castle1,
        flagOffset: .init(x: 0.038, y: 0.3),
    )
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
