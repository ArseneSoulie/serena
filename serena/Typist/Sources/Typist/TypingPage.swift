import DesignSystem
import SwiftUI

struct TextToType {
    let value: String
    let x: Double
    var y: Double
}

public struct TypingPage: View {
    @State private var text: String = ""
    @State private var textsToType: [TextToType] = []

    public init() {
        difficultyScale = startingDifficulty
        health = maxHealth
    }

    @State var isPlaying: Bool = true
    @State var score: Int = 0
    @State var health: Int
    @State var difficultyScale: Double

    @State var lastTime: Date = .now
    @State var timeSinceLastSpawn: TimeInterval = 0
    @State var deltaTime: TimeInterval = 0

    @State var shakeTrigger: CGFloat = 0

    var fallSpeed: CGFloat {
        (1 / timeToReachTheBottom) * difficultyScale
    }

    var timeUntilNextSpawn: TimeInterval { 10 / difficultyScale }

    let maxHealth = 3
    let timeToReachTheBottom: CGFloat = 20
    let startingDifficulty: Double = 1

    public var body: some View {
        VStack {
            HStack {
                ForEach(1 ... maxHealth, id: \.self) { index in
                    if index <= health {
                        Image(systemName: "circle.fill")
                    } else {
                        Image(systemName: "circle")
                    }
                }
            }.padding(.horizontal)
            HStack {
                Text("Points: \(score)")
                Spacer()
                Text("Difficulty \(difficultyScale.formatted(.number.precision(.significantDigits(2))))")
            }.padding(.horizontal)

            if isPlaying {
                Color.yellow
                    .overlay {
                        GeometryReader { geometry in
                            ForEach(textsToType, id: \.value) { textToType in
                                HStack {
                                    Spacer().frame(maxWidth: textToType.x * geometry.size.width)
                                    TextWithHighlight(fullText: textToType.value, textToMatch: text)
                                    Spacer().frame(maxWidth: (1 - textToType.x) * geometry.size.width)
                                }.offset(.init(width: 0, height: textToType.y * geometry.size.height))
                            }
                        }
                    }
                    .shake(amount: 2, shakesPerUnit: 5, shakeTrigger)
                    .onReceive(Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()) {
                        guard isPlaying else { return }
                        updateTimingInternals(currentFrameTime: $0)
                        slideDown()
                        takeDamage()
                        spawnIfNeeded()
                    }
                    .typography(.body)
            } else {
                Color.orange.overlay {
                    VStack {
                        Spacer()
                        Text("Finished")
                        Text("Total score: \(score)")
                            .typography(.largeTitle)
                        Button("Start again ?") { onStartAgainTapped() }
                        Spacer()
                    }
                }
            }

            KanaTextFieldView(text: $text, preferredLanguageCode: "ja", onSubmit: onSubmit)
                .border(.red)
                .fixedSize(horizontal: false, vertical: true)
            Button("add") {
                spawnNewText()
            }
        }.onAppear(perform: spawnNewText)
    }

    func onStartAgainTapped() {
        difficultyScale = startingDifficulty
        health = maxHealth
        score = 0
        isPlaying = true
        textsToType = []
    }

    func isTextMatchingInput(textToType: TextToType) -> Bool {
        text == textToType.value
    }

    func updateTimingInternals(currentFrameTime: Date) {
        deltaTime = currentFrameTime.timeIntervalSince(lastTime)
        timeSinceLastSpawn += deltaTime
        lastTime = currentFrameTime
    }

    func spawnIfNeeded() {
        if timeSinceLastSpawn >= timeUntilNextSpawn {
            spawnNewText()
        }
    }

    func slideDown() {
        for index in textsToType.indices {
            textsToType[index].y += fallSpeed * deltaTime
            textsToType[index].y += fallSpeed * deltaTime * (1 / Double(textsToType[index].value.count * 2))
        }
    }

    func spawnNewText() {
        textsToType.append(.init(value: generateRandomString(), x: Double.random(in: 0 ... 1), y: 0))
        timeSinceLastSpawn = 0
    }

    func takeDamage() {
        let filteredTextsToType = textsToType.filter { $0.y < 1 }
        guard filteredTextsToType.count != textsToType.count else { return }

        textsToType = filteredTextsToType

        withAnimation(.easeOut(duration: 0.2)) {
            health -= 1
            shakeTrigger += 1
        }

        let difficultyToReduce = (difficultyScale - startingDifficulty) / 2
        difficultyScale -= max(difficultyToReduce, 0.05)

        if health <= 0 {
            isPlaying = false
        }
    }

    func onSubmit() {
        checkWordsAndGainPoints()
        text = ""
    }

    func checkWordsAndGainPoints() {
        let successfullyTypedTexts = textsToType.filter(isTextMatchingInput(textToType:))
        guard successfullyTypedTexts.count > 0 else { return }

        textsToType.removeAll(where: isTextMatchingInput(textToType:))

        score += successfullyTypedTexts.reduce(0) { partialResult, textToType in
            partialResult + Int(Double(textToType.value.count) * difficultyScale)
        }
        difficultyScale += 0.05

        spawnNewText()
    }
}

#Preview {
    TypingPage()
}

func generateRandomString() -> String {
    let characters = "あいうえお"
    let randomLength = Int.random(in: 1 ... 5)
    let randomString = String((0 ..< randomLength).compactMap { _ in
        characters.randomElement()
    })

    return randomString
}
