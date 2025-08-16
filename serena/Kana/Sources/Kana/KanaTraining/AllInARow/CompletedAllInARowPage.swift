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

struct CompletedTileData: Identifiable {
    let kana: Kana
    let completionState: CompletionState

    var id: String { kana.kanaValue }
}

struct CompletedAllInARowPage: View {
    let kanas: [Kana]

    let failedKanas: Set<Kana>
    let remainingKanas: Set<Kana>

    let onTryAgainTapped: () -> Void
    let onLevelUpsTapped: () -> Void
    let onGoBackTapped: () -> Void

    @State var tiles: [CompletedTileData] = []

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack {
                        Text(localized("Completed !"))
                            .typography(.headline)
                            .padding()
                        Text(completionText)

                        let columns = [GridItem(.adaptive(minimum: 50))]

                        LazyVGrid(columns: columns) {
                            ForEach(tiles) {
                                Button($0.kana.kanaValue) {}
                                    .buttonStyle(TileButtonStyle(
                                        tileSize: .largeEntry,
                                        tileKind: .custom($0.completionState.color),
                                    ))
                            }
                        }.padding()
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(white: 0.91))
                            }
                            .padding()

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
            guard tiles.isEmpty else { return }
            Task {
                for kana in kanas {
                    try? await Task.sleep(for: .seconds(0.1))
                    withAnimation {
                        tiles.append(
                            .init(kana: kana, completionState: completionState(for: kana)),
                        )
                    }
                }
            }
        }
    }

    var isPerfect: Bool {
        failedKanas.isEmpty && remainingKanas.isEmpty
    }

    var completionText: String {
        if isPerfect {
            return localized("Perfect run ! 🎉")
        } else {
            let failedText = failedKanas.isEmpty ? "" : "\(localized("Incorrect")): \(failedKanas.count) "
            let skippedText = remainingKanas.isEmpty ? "" : "\(localized("Passed")): \(remainingKanas.count) "
            let succeededText = "\(localized("Correct")): \(kanas.count - (remainingKanas.count + failedKanas.count)) "

            return succeededText + failedText + skippedText
        }
    }

    func completionState(for kana: Kana) -> CompletionState {
        if failedKanas.contains(kana) { .failed } else if remainingKanas.contains(kana) { .skipped } else { .success }
    }
}

#Preview {
    CompletedAllInARowPage(
        kanas: [
            .hiragana(value: "a"),
            .hiragana(value: "i"),
            .hiragana(value: "u"),
            .hiragana(value: "e"),
            .hiragana(value: "o"),
            .hiragana(value: "ka"),
            .hiragana(value: "ki"),
            .hiragana(value: "ku"),
        ],
        failedKanas: [.hiragana(value: "ka")],
        remainingKanas: [],
        onTryAgainTapped: {},
        onLevelUpsTapped: {},
        onGoBackTapped: {},
    )
}
