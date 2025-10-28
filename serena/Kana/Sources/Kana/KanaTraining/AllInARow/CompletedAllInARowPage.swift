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
    let result: AllInARowResult

    let onTryAgainTapped: () -> Void
    let onLevelUpsTapped: () -> Void
    let onGoBackTapped: () -> Void

    @State var displayedKanas: [Kana] = []
    @State var shouldShowRomajiForFailedKanas: Bool = false

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack {
                        Text(.completed)
                            .typography(.headline)
                            .padding()
                        if isPerfect {
                            Text(.perfectRun🎉)
                        }

                        let columns = [GridItem(.adaptive(minimum: 50))]
                        LazyVGrid(columns: columns) {
                            ForEach(result.succeededKanas, id: \.kanaValue) { successKana in
                                ResultTileView(kana: successKana, backgroundColor: .green, shouldShowRomaji: false)
                                    .opacity(displayedKanas.contains(successKana) ? 1 : 0)
                            }
                            ForEach(result.skippedKanas, id: \.kanaValue) { skippedKana in
                                ResultTileView(kana: skippedKana, backgroundColor: .secondary, shouldShowRomaji: false)
                                    .opacity(displayedKanas.contains(skippedKana) ? 1 : 0)
                            }
                            ForEach(result.failedKanas, id: \.kanaValue) { failedKana in
                                ResultTileView(
                                    kana: failedKana,
                                    backgroundColor: .red,
                                    shouldShowRomaji: shouldShowRomajiForFailedKanas,
                                )
                                .opacity(displayedKanas.contains(failedKana) ? 1 : 0)
                            }
                        }
                        .padding()
                        .background { RoundedRectangle(cornerRadius: 16).fill(Color(white: 0.91)) }
                        .padding()

                        if result.succeededKanas.count != 0 {
                            Text("\(String(localized: .correct)): \(result.succeededKanas.count)")
                                .foregroundStyle(.green)
                        }

                        if result.skippedKanas.count != 0 {
                            Text("\(String(localized: .passed)): \(result.skippedKanas.count)")
                                .foregroundStyle(.secondary)
                        }

                        if result.failedKanas.count != 0 {
                            Text("\(String(localized: .incorrect)): \(result.failedKanas.count)")
                                .foregroundStyle(.red)
                        }

                        if isPerfect {
                            DancingKaomojiView()
                        }
                        Spacer()
                    }
                }

                HStack {
                    Button(.tryAgainWithSelection, action: onTryAgainTapped)
                    Button(.levelUps, action: onLevelUpsTapped)
                }.buttonStyle(.borderedProminent)
                    .padding()
                Button(.goBackToSelection, action: onGoBackTapped)
                    .buttonStyle(.borderless)
            }.padding()
            if isPerfect {
                ConfettiView(count: 100, emitPoint: .init(x: UIScreen.main.bounds.width / 2, y: 0))
            }
        }
        .animation(.default, value: shouldShowRomajiForFailedKanas)
        .onAppear {
            guard displayedKanas.isEmpty else { return }
            Task {
                for kana in result.allKanas {
                    try? await Task.sleep(for: .seconds(0.1))
                    withAnimation {
                        displayedKanas.append(kana)
                    }
                }
            }
        }
        .toolbar {
            if result.failedKanas.count != 0 {
                Toggle(isOn: $shouldShowRomajiForFailedKanas) {
                    Text(.showRomajiForFailed)
                }.padding()
            }
        }
    }

    var isPerfect: Bool {
        result.failedKanas.count == 0 && result.skippedKanas.count == 0
    }
}

struct ResultTileView: View {
    let kana: Kana
    let backgroundColor: Color
    let shouldShowRomaji: Bool

    var body: some View {
        Button(action: {}, label: {
            VStack {
                Text(kana.kanaValue)
                if shouldShowRomaji {
                    Text(kana.romajiValue)
                        .typography(.callout)
                }
            }
        })
        .buttonStyle(TileButtonStyle(tileSize: .medium, tileKind: .custom(backgroundColor)))
    }
}

extension AllInARowResult {
    var allKanas: [Kana] { succeededKanas + skippedKanas + failedKanas }
}

#Preview {
    CompletedAllInARowPage(
        result: .init(
            succeededKanas: [
                .hiragana(value: "a"),
                .hiragana(value: "i"),
                .hiragana(value: "u"),
                .hiragana(value: "e"),
                .hiragana(value: "o"),
                .hiragana(value: "ka"),
                .hiragana(value: "ki"),
                .hiragana(value: "ku"),
            ],
            skippedKanas: [],
            failedKanas: [],
        ),
        onTryAgainTapped: {},
        onLevelUpsTapped: {},
        onGoBackTapped: {},
    )
}
