import DesignSystem
import FoundationModels
import SwiftUI

enum CompletionState {
    case success
    case failed
    case skipped

    var color: Color {
        switch self {
        case .success: .green
        case .failed: .red
        case .skipped: .gray
        }
    }
}

struct KanaWithCompletionState: Identifiable, Equatable {
    let kana: Kana
    let completionState: CompletionState

    var id: String {
        kana.kanaValue
    }
}

struct CompletedAllInARowPage: View {
    let kanasWithCompletionState: [KanaWithCompletionState]

    let onTryAgainTapped: () -> Void
    let onLevelUpsTapped: () -> Void
    let onGoBackTapped: () -> Void

    @State var displayedKanas: [KanaWithCompletionState] = []

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack {
                        Text(localized("Completed !"))
                            .typography(.headline)
                            .padding()
                        if isPerfect {
                            Text(localized("Perfect run ! 🎉"))
                        }

                        let columns = [GridItem(.adaptive(minimum: 50))]
                        LazyVGrid(columns: columns) {
                            ForEach(kanasWithCompletionState) { kanaWithState in
                                Button(kanaWithState.kana.kanaValue) {}
                                    .buttonStyle(TileButtonStyle(
                                        tileSize: .medium,
                                        tileKind: .custom(kanaWithState.completionState.color),
                                    ))
                                    .opacity(displayedKanas.contains(where: { $0 == kanaWithState }) ? 1 : 0)
                            }
                        }
                        .padding()
                        .background { RoundedRectangle(cornerRadius: 16).fill(Color(white: 0.91)) }
                        .padding()

                        if succeededKanaCount != 0 {
                            Text("\(localized("Correct")): \(succeededKanaCount)")
                                .foregroundStyle(.green)
                        }

                        if skippedKanaCount != 0 {
                            Text("\(localized("Passed")): \(skippedKanaCount)")
                                .foregroundStyle(.secondary)
                        }

                        if failedKanaCount != 0 {
                            Text("\(localized("Incorrect")): \(failedKanaCount)")
                                .foregroundStyle(.red)
                        }

                        if isPerfect {
                            DancingKaomojiView()
                        }
                        Spacer()
                    }
                }

                HStack {
                    Button(localized("Try again with selection"), action: onTryAgainTapped)
                    Button(localized("Level ups"), action: onLevelUpsTapped)
                }.buttonStyle(.borderedProminent)
                    .padding()
                Button(localized("Go back to selection"), action: onGoBackTapped)
                    .buttonStyle(.borderless)
            }.padding()
            if isPerfect {
                ConfettiView(count: 100, emitPoint: .init(x: UIScreen.main.bounds.width / 2, y: 0))
            }
        }
        .onAppear {
            guard displayedKanas.isEmpty else { return }
            Task {
                for kanaWithState in kanasWithCompletionState {
                    try? await Task.sleep(for: .seconds(0.1))
                    withAnimation {
                        displayedKanas.append(kanaWithState)
                    }
                }
            }
        }
    }

    var failedKanaCount: Int {
        kanasWithCompletionState.count(where: { $0.completionState == .failed })
    }

    var skippedKanaCount: Int {
        kanasWithCompletionState.count(where: { $0.completionState == .skipped })
    }

    var succeededKanaCount: Int {
        kanasWithCompletionState.count(where: { $0.completionState == .success })
    }

    var isPerfect: Bool {
        failedKanaCount == 0 && skippedKanaCount == 0
    }
}

#Preview {
    CompletedAllInARowPage(
        kanasWithCompletionState: [
            .init(kana: .hiragana(value: "a"), completionState: .skipped),
            .init(kana: .hiragana(value: "i"), completionState: .skipped),
            .init(kana: .hiragana(value: "u"), completionState: .skipped),
            .init(kana: .hiragana(value: "e"), completionState: .skipped),
            .init(kana: .hiragana(value: "o"), completionState: .skipped),
            .init(kana: .hiragana(value: "ka"), completionState: .skipped),
            .init(kana: .hiragana(value: "ki"), completionState: .skipped),
            .init(kana: .hiragana(value: "ku"), completionState: .skipped),
        ],
        onTryAgainTapped: {},
        onLevelUpsTapped: {},
        onGoBackTapped: {},
    )
}
