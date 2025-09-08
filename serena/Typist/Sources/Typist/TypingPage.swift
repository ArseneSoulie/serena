import DesignSystem
import SwiftUI

struct TextToType {
    let value: String
    let x: Double
    var y: Double
}

public struct TypingPage: View {
    @State private var text: String = ""
    @State private var textsToType: [TextToType] = [
        .init(value: "arigatou", x: 0.2, y: 0),
        .init(value: "ありがとう", x: 0.5, y: 0),
        .init(value: "フラン", x: 0.8, y: 0),
    ]

    public init() {}

    @State var score: Int = 0

    let timeToReachTheBottom: CGFloat = 20
    var fallSpeed: CGFloat {
        1 / timeToReachTheBottom
    }

    @State var lastTime: Date = .now

    public var body: some View {
        VStack {
            Text("Kana Typing Page")
            HStack {
                Text("Points: 124")
                Spacer()
                Text("Level 1")
            }.padding(.horizontal)
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
                .onReceive(Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()) {
                    slideDown(currentFrameTime: $0)
                    cleanupAndTakeDamage()
                }
                .typography(.body)

            VStack(alignment: .trailing) {
                KanaTextFieldView(text: $text, preferredLanguageCode: "ja", onSubmit: onSubmit)
                    .border(.red)
                    .fixedSize(horizontal: false, vertical: true)
                    .onSubmit {
                        print("hei")
                    }
            }
            Button("add") {
                textsToType.append(.init(value: String("あいうえお".shuffled()), x: Double.random(in: 0 ... 1), y: 0))
            }
        }
    }

    func slideDown(currentFrameTime: Date) {
        let deltaTime = currentFrameTime.timeIntervalSince(lastTime)
        lastTime = currentFrameTime
        for index in textsToType.indices {
            textsToType[index].y += fallSpeed * deltaTime
        }
    }

    func cleanupAndTakeDamage() {
        textsToType = textsToType.filter { $0.y < 1 }
    }

    func onSubmit() {
        print("eoifnezoizen")
    }
}

#Preview {
    TypingPage()
}
