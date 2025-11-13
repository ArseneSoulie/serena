import Combine
import FoundationModels
import ReinaDB
import Sharing
import SQLiteData
import SwiftUI

@MainActor
class TypingViewModel: ObservableObject {
    @Dependency(\.defaultDatabase) var database
    @Shared(.appStorage("typingScore")) var typingScore: [TypingLevel: Int] = [:]

    @Published private(set) var textsToType: [TextToType] = []
    @Published private(set) var scorePopups: [ScorePopup] = []
    @Published private(set) var score: Int = 0
    @Published private(set) var health: Int
    @Published private(set) var difficultyScale: Double
    @Published private(set) var comboCount: Int = 0
    @Published private(set) var shakeTrigger: CGFloat = 0
    @Published private(set) var showLevelUp: Bool = false
    @Published private(set) var isPlaying: Bool = true
    @Published private(set) var isHighScore: Bool = false
    @Published private(set) var bestCombo: Int = 0
    @Published var inputText: String = ""
    @Published var autoSubmitEnabled: Bool = true

    var currentDifficulty: Int {
        Int(difficultyScale)
    }

    // MARK: - Internal Game State

    private var lastFrameTime: Date = .now
    private var timeSinceLastSpawn: TimeInterval = 0
    private var deltaTime: TimeInterval = 0
    private var lastLevelUpAt: Date = .distantPast
    private var gameLoopTimer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    private let level: TypingLevel

    // MARK: - Tuning

    private var fallSpeed: CGFloat { (1 / timeToReachTheBottom) * (Double(currentDifficulty + 1) / 2) }
    private var timeUntilNextSpawn: TimeInterval { 10 / difficultyScale }
    private let maxHealth = 3
    private let timeToReachTheBottom: CGFloat = 20
    private let startingDifficulty: Double = 1
    private var comboMultiplier: Double { 1.0 + Double(comboCount) * 0.1 }

    init(level: TypingLevel) {
        self.level = level
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

    let targetFps = 60.0

    func startGame() {
        DispatchQueue.main.async {
            self.gameLoopTimer = Timer.publish(every: 1.0 / self.targetFps, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] currentTime in
                    self?.onTick(currentTime: currentTime)
                }
        }
        spawnNewText()
    }

    func stopGame() {
        withAnimation {
            isPlaying = false
        }
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

    func endGame() {
        bestCombo = max(bestCombo, comboCount)

        saveNewHighScoreIfNeeded()
        stopGame()
    }

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
        withAnimation {
            isPlaying = true
        }
        isHighScore = false
        startGame()
    }

    func onSubmit() {
        evaluateMatchesAndScore(with: inputText)
        inputText = ""
    }

    // MARK: - Game Logic

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
        guard let nextWord = getWordForCurrentLevel() else {
            assertionFailure("Word not found check the query !")
            return
        }

        withAnimation {
            textsToType.append(.init(word: nextWord, x: Double.random(in: 0.1 ... 0.9), y: 0))
        }
        timeSinceLastSpawn = 0
    }

    private func getWordForCurrentLevel() -> ReinaWord? {
        switch level {
        case .kanaOnly:
            let characters = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん"
            guard let character = characters.randomElement() else { return nil }
            return .init(id: UUID().uuidString, writing: nil, reading: String(character), easinessScore: 10)

        case .easyWords:
            var randomWord: ReinaWord?
            withErrorReporting {
                randomWord = try database.read { db in
                    try ReinaWord
                        .where { $0.easinessScore == 10 }
                        .order { _ in #sql("RANDOM()") }
                        .fetchOne(db)
                }
            }
            return randomWord

        case .fullDictionnary:
            var randomWord: ReinaWord?
            withErrorReporting {
                randomWord = try database.read { db in
                    try ReinaWord
                        .where { $0.easinessScore >= 1 }
                        .order { _ in #sql("RANDOM()") }
                        .fetchOne(db)
                }
            }
            return randomWord
        }
    }

    private func handleAutoSubmit(for text: String) {
        guard autoSubmitEnabled, !text.isEmpty else { return }
        evaluateMatchesAndScore(with: text, onSuccess: { [weak self] in self?.inputText = "" })
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

    private func saveNewHighScoreIfNeeded() {
        let previousHighScore = typingScore[level] ?? 0
        isHighScore = score > previousHighScore
        if isHighScore {
            $typingScore.withLock { $0[level] = score }
        }
    }

    private func evaluateMatchesAndScore(with inputText: String, onSuccess: (() -> Void)? = nil) {
        let matched = textsToType.filter { $0.word.matches(input: inputText) }
        guard !matched.isEmpty else { return }

        textsToType.removeAll { $0.word.matches(input: inputText) }

        let base = matched.reduce(0.0) { $0 + Double($1.word.reading.count) * $1.word.difficultyMultiplier }
        let points = Int(base * comboMultiplier * difficultyScale)
        score += points

        for item in matched {
            addScorePopup(for: item, gained: points / matched.count)
        }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        comboCount += matched.count
        bestCombo = max(bestCombo, comboCount)

        let previousDifficulty = difficultyScale
        withAnimation(.easeInOut(duration: 2)) {
            difficultyScale += 0.1 * Double(matched.count)
        }
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

extension ReinaWord {
    var difficultyMultiplier: Double {
        1 + (1 - Double(easinessScore) / 10)
    }

    func matches(input: String) -> Bool {
        reading == input || writing == input
    }
}
