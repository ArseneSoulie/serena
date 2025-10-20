import Combine
import SwiftUI

@MainActor
class GameEngine: ObservableObject {
    @Published private(set) var textsToType: [TextToType] = []
    @Published private(set) var scorePopups: [ScorePopup] = []
    @Published private(set) var score: Int = 0
    @Published private(set) var health: Int
    @Published private(set) var difficultyScale: Double
    @Published private(set) var comboCount: Int = 0
    @Published private(set) var shakeTrigger: CGFloat = 0
    @Published private(set) var showLevelUp: Bool = false
    @Published private(set) var isPlaying: Bool = true
    @Published private(set) var bestCombo: Int = 0
    @Published var inputText: String = ""
    @Published var autoSubmitEnabled: Bool = true

    // MARK: Internal Game State

    private var lastFrameTime: Date = .now
    private var timeSinceLastSpawn: TimeInterval = 0
    private var deltaTime: TimeInterval = 0
    private var lastLevelUpAt: Date = .distantPast
    private var gameLoopTimer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()

    // MARK: Tuning

    private var fallSpeed: CGFloat { (1 / timeToReachTheBottom) * difficultyScale }
    private var timeUntilNextSpawn: TimeInterval { 10 / difficultyScale }
    private let maxHealth = 3
    private let timeToReachTheBottom: CGFloat = 20
    private let startingDifficulty: Double = 1
    private var comboMultiplier: Double { 1.0 + Double(comboCount) * 0.1 }

    init() {
        health = maxHealth
        difficultyScale = startingDifficulty

        $inputText
            .debounce(for: .milliseconds(50), scheduler: RunLoop.main)
            .sink { [weak self] newText in
                self?.handleAutoSubmit(for: newText)
            }
            .store(in: &cancellables)
    }

    // MARK: - Game Loop Control

    func startGame() {
        DispatchQueue.main.async {
            self.gameLoopTimer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] currentTime in
                    self?.onTick(currentTime: currentTime)
                }
        }
        spawnNewText()
    }

    func stopGame() {
        isPlaying = false
        showLevelUp = false
        textsToType = []
        scorePopups = []
        gameLoopTimer?.cancel()
        gameLoopTimer = nil
    }

    private func onTick(currentTime: Date) {
        guard isPlaying else { return }
        updateTiming(currentFrameTime: currentTime)
        moveTextsDown()
        applyDamageIfNeeded()
        spawnIfReady()
        updateScorePopups()
    }

    // MARK: - Public Game Actions

    func restartGame() {
        lastFrameTime = .now
        timeSinceLastSpawn = 0
        deltaTime = 0
        difficultyScale = startingDifficulty
        health = maxHealth
        score = 0
        textsToType = []
        scorePopups = []
        comboCount = 0
        bestCombo = 0
        showLevelUp = false
        isPlaying = true
        startGame()
    }

    func onSubmit() {
        evaluateMatchesAndScore(with: inputText)
        inputText = ""
    }

    private func handleAutoSubmit(for text: String) {
        guard autoSubmitEnabled, !text.isEmpty else { return }
        evaluateMatchesAndScore(with: text, onSuccess: { [weak self] in self?.inputText = "" })
    }

    // MARK: - Game Logic (All private)

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
        }
    }

    private func spawnNewText() {
        withAnimation {
            textsToType.append(.init(value: generateRandomString(), x: Double.random(in: 0.1 ... 0.9), y: 0))
        }
        timeSinceLastSpawn = 0
    }

    private func applyDamageIfNeeded() {
        let countBefore = textsToType.count
        textsToType.removeAll { $0.y >= 1.0 }
        let damage = countBefore - textsToType.count

        guard damage > 0 else { return }

        withAnimation {
            health -= damage
            shakeTrigger += CGFloat(damage)
            comboCount = 0
        }

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        if difficultyScale > startingDifficulty {
            difficultyScale = max(startingDifficulty, difficultyScale - 0.2 * Double(damage))
        }

        if health <= 0 {
            endGame()
        }
    }

    private func endGame() {
        bestCombo = max(bestCombo, comboCount)

        stopGame()
    }

    private func evaluateMatchesAndScore(with inputText: String, onSuccess: (() -> Void)? = nil) {
        let matched = textsToType.filter { $0.value == inputText }
        guard !matched.isEmpty else { return }

        textsToType.removeAll { $0.value == inputText }

        let base = matched.reduce(0) { $0 + $1.value.count }
        let points = Int(Double(base) * comboMultiplier * difficultyScale)
        score += points

        for item in matched {
            addScorePopup(for: item, gained: points / matched.count)
        }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        comboCount += matched.count
        bestCombo = max(bestCombo, comboCount)

        let previousDifficulty = difficultyScale
        difficultyScale += 0.05 * Double(matched.count)
        if Int(difficultyScale) > Int(previousDifficulty) {
            triggerLevelUpAnimation()
        }

        spawnNewText()
        onSuccess?()
    }

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
                self.showLevelUp = false
            }
        }
    }
}
