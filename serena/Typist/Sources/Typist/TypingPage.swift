import DesignSystem
import SwiftUI
import UIKit

// MARK: - Models

struct TextToType: Equatable {
    let value: String
    let x: Double
    var y: Double
}

struct ScorePopup: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let x: Double
    let y: Double
    var opacity: Double = 1.0
    var offsetY: CGFloat = 0
}

// MARK: - Typing Page

public struct TypingPage: View {
    // MARK: State - Input and Playfield

    @State private var inputText: String = ""
    @State private var textsToType: [TextToType] = []
    @State private var isFirstResponder: Bool = true

    // MARK: State - Game

    @State private var isPlaying: Bool = true
    @State private var score: Int = 0
    @State private var health: Int
    @State private var difficultyScale: Double
    @State private var lastFrameTime: Date = .now
    @State private var timeSinceLastSpawn: TimeInterval = 0
    @State private var deltaTime: TimeInterval = 0
    @State private var shakeTrigger: CGFloat = 0

    // MARK: State - Scoring and Feedback

    @State private var scorePopups: [ScorePopup] = []
    @State private var comboCount: Int = 0
    @State private var bestCombo: Int = 0
    private var comboMultiplier: Double { 1.0 + Double(comboCount) * 0.1 }

    // MARK: State - Options and Overlays

    @State private var autoSubmitEnabled: Bool = false
    @State private var showLevelUp: Bool = false
    @State private var lastLevelUpAt: Date = .distantPast

    // MARK: Environment / Accessibility

    private var reduceMotion: Bool { UIAccessibility.isReduceMotionEnabled }

    // MARK: Tuning

    private var fallSpeed: CGFloat { (1 / timeToReachTheBottom) * difficultyScale }
    private var timeUntilNextSpawn: TimeInterval { 10 / difficultyScale }

    private let maxHealth = 3
    private let timeToReachTheBottom: CGFloat = 20
    private let startingDifficulty: Double = 1
    private let maxDifficultyForGradient: Double = 3

    // MARK: Init

    public init() {
        difficultyScale = startingDifficulty
        health = maxHealth
    }

    // MARK: Body

    public var body: some View {
        ZStack {
            animatedBackground
                .ignoresSafeArea()

            VStack(spacing: 10) {
                if isPlaying {
                    topBars
                }

                Group {
                    if isPlaying {
                        playfield
                    } else {
                        finishCard
                    }
                }
                .transaction { tx in tx.disablesAnimations = true }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                if isPlaying {
                    inputBar
                }
            }
        }
        .onAppear {
            spawnNewText()
            isFirstResponder = true
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Toggle("Auto-submit", isOn: $autoSubmitEnabled)
            }
        }
        .navigationTitle("Typing")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: UI - Top Bars

    private var topBars: some View {
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
                Text("Difficulty \(difficultyScale.formatted(.number.precision(.significantDigits(2))))")
            }
            .padding(.horizontal)
        }
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
                Text("Combo \(comboCount)  •  x\(comboMultiplier, format: .number.precision(.fractionLength(1)))")
                    .foregroundStyle(.orange)
                    .typography(.callout)
                    .transition(.opacity)
            }
        }
    }

    // MARK: UI - Playfield

    private var playfield: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
                .overlay {
                    GeometryReader { geometry in
                        ZStack(alignment: .topLeading) {
                            ForEach(textsToType.indices, id: \.self) { idx in
                                let textToType = textsToType[idx]
                                HStack {
                                    Spacer().frame(maxWidth: textToType.x * geometry.size.width)
                                    TextWithHighlight(fullText: textToType.value, textToMatch: inputText)
                                        .typography(.body)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(.ultraThinMaterial, in: Capsule())
                                        .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 3)
                                    Spacer().frame(maxWidth: (1 - textToType.x) * geometry.size.width)
                                }
                                .offset(.init(width: 0, height: textToType.y * geometry.size.height))
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
                    }
                }

            if showLevelUp {
                Text("Level Up!")
                    .typography(.headline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.ultraThinMaterial, in: Capsule())
                    .overlay { Capsule().stroke(.orange, lineWidth: 2) }
                    .shadow(radius: 6)
                    .transition(.opacity.combined(with: .scale))
                    .padding(.trailing, 12)
                    .padding(.top, 8)
            }
        }
        .shake(
            amount: reduceMotion ? 0 : 2,
            shakesPerUnit: 5,
            rotation: reduceMotion ? .degrees(0) : .degrees(2),
            shakeTrigger,
        )
        .modifier(PlayLoopModifier(
            isPlaying: isPlaying,
            onTick: { currentTime in
                updateTiming(currentFrameTime: currentTime)
                moveTextsDown()
                applyDamageIfNeeded()
                spawnIfReady()
                autoSubmitIfNeeded()
                updateScorePopups()
            },
        ))
        .typography(.body)
    }

    // MARK: UI - Finish Card

    private var finishCard: some View {
        VStack {
            Spacer()
            VStack(spacing: 14) {
                Text("Finished")
                    .typography(.title).bold()
                VStack(spacing: 6) {
                    Text("Total score")
                        .foregroundStyle(.secondary)
                    Text("\(score)")
                        .typography(.largeTitle)
                }
                if bestCombo > 0 {
                    Text(
                        "Best combo: \(bestCombo)  •  x\(1.0 + Double(bestCombo) * 0.1, format: .number.precision(.fractionLength(1)))",
                    )
                    .foregroundStyle(.orange)
                }
                Button {
                    restartGame()
                    isFirstResponder = true
                } label: {
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

    // MARK: UI - Input Bar

    private var inputBar: some View {
        KanaTextFieldView(
            text: $inputText,
            preferredLanguageCode: "ja",
            onSubmit: handleSubmit,
            isFirstResponder: $isFirstResponder,
        )
        .padding(.horizontal, 12)
        .frame(minHeight: 36, maxHeight: 44)
        .background(.ultraThinMaterial, in: Capsule())
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    // MARK: UI - Background

    private var animatedBackground: some View {
        let t = min(difficultyScale / maxDifficultyForGradient, 1.0)
        let start = Color(hue: 210 / 360, saturation: 0.35 + 0.10 * t, brightness: 1)
        let end = Color(hue: (260 - 230 * t) / 360, saturation: 0.50 + 0.35 * t, brightness: 0.95 + 0.05 * t)

        return LinearGradient(colors: [start, end], startPoint: .topLeading, endPoint: .bottomTrailing)
            .animation(.easeInOut(duration: 0.6), value: difficultyScale)
    }

    // MARK: Game Control

    private func restartGame() {
        difficultyScale = startingDifficulty
        health = maxHealth
        score = 0
        isPlaying = true
        textsToType = []
        scorePopups = []
        comboCount = 0
        showLevelUp = false
    }

    private func handleSubmit() {
        evaluateMatchesAndScore()
        inputText = ""
        isFirstResponder = true
    }

    // MARK: Game Loop Helpers

    private func updateTiming(currentFrameTime: Date) {
        deltaTime = currentFrameTime.timeIntervalSince(lastFrameTime)
        timeSinceLastSpawn += deltaTime
        lastFrameTime = currentFrameTime
    }

    private func spawnIfReady() {
        if timeSinceLastSpawn >= timeUntilNextSpawn {
            spawnNewText()
        }
    }

    private func moveTextsDown() {
        for index in textsToType.indices {
            textsToType[index].y += fallSpeed * deltaTime
            textsToType[index].y += fallSpeed * deltaTime * (1 / Double(textsToType[index].value.count * 2))
        }
    }

    private func spawnNewText() {
        textsToType.append(.init(value: generateRandomString(), x: Double.random(in: 0 ... 1), y: 0))
        timeSinceLastSpawn = 0
    }

    private func applyDamageIfNeeded() {
        let filtered = textsToType.filter { $0.y < 1 }
        guard filtered.count != textsToType.count else { return }

        textsToType = filtered

        withAnimation(.easeOut(duration: 0.2)) {
            health -= 1
            shakeTrigger += 1
            comboCount = 0
        }

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        if difficultyScale > startingDifficulty {
            let surplus = difficultyScale - startingDifficulty
            difficultyScale = startingDifficulty + surplus / 2
        }

        if health <= 0 {
            bestCombo = max(bestCombo, comboCount)
            showLevelUp = false
            scorePopups.removeAll()
            isPlaying = false
            isFirstResponder = false
        }
    }

    // MARK: Matching and Scoring

    private func isExactMatch(_ item: TextToType) -> Bool {
        inputText == item.value
    }

    private func evaluateMatchesAndScore() {
        let matched = textsToType.filter(isExactMatch)
        guard !matched.isEmpty else { return }

        textsToType.removeAll(where: isExactMatch)

        let base = matched.reduce(0) { running, item in
            running + Int(Double(item.value.count) * difficultyScale)
        }

        let total = Int(Double(base) * comboMultiplier)
        score += total

        for item in matched {
            let wordBase = Int(Double(item.value.count) * difficultyScale)
            let wordPoints = Int(Double(wordBase) * comboMultiplier)
            addScorePopup(for: item, gained: wordPoints)
        }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        comboCount += matched.count
        bestCombo = max(bestCombo, comboCount)

        let previousDifficulty = difficultyScale
        difficultyScale += 0.05
        if difficultyScale > previousDifficulty {
            triggerLevelUpAnimation()
        }

        spawnNewText()
    }

    // MARK: Auto-submit

    private func autoSubmitIfNeeded() {
        guard autoSubmitEnabled else { return }
        guard !inputText.isEmpty else { return }
        guard textsToType.contains(where: isExactMatch) else { return }
        handleSubmit()
    }

    // MARK: Popups and Overlays

    private func addScorePopup(for typed: TextToType, gained: Int) {
        let popup = ScorePopup(text: "+\(gained)", x: typed.x, y: typed.y)
        scorePopups.append(popup)
    }

    private func updateScorePopups() {
        guard !scorePopups.isEmpty else { return }
        for idx in scorePopups.indices {
            scorePopups[idx].offsetY -= CGFloat(30 * deltaTime)
            scorePopups[idx].opacity -= deltaTime * 1.5
        }
        scorePopups.removeAll { $0.opacity <= 0 }
    }

    private func triggerLevelUpAnimation() {
        let now = Date()
        guard !showLevelUp, now.timeIntervalSince(lastLevelUpAt) > 0.6 else { return }
        lastLevelUpAt = now

        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            showLevelUp = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.easeOut(duration: 0.25)) {
                showLevelUp = false
            }
        }
    }
}

// MARK: - Play Loop Modifier

private struct PlayLoopModifier: ViewModifier {
    let isPlaying: Bool
    let onTick: (Date) -> Void

    func body(content: Content) -> some View {
        if isPlaying {
            content
                .onReceive(Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()) { date in
                    onTick(date)
                }
        } else {
            content
        }
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        TypingPage()
    }
}

// MARK: - Utilities

func generateRandomString() -> String {
    let characters = "あいうえお"
    let randomLength = Int.random(in: 1 ... 5)
    let randomString = String((0 ..< randomLength).compactMap { _ in
        characters.randomElement()
    })
    return randomString
}
