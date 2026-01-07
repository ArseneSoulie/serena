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

    @State private var animationTask: Task<Void, Never>?

    var body: some View {
        ZStack {
            List {
                Section {
                    VStack {
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
                        .onTapGesture {
                            skipAnimation()
                        }

                        if isPerfect {
                            Text(.perfectRun🎉)
                        } else {
                            if result.succeededKanas.count != 0 {
                                Text(.correct(result.succeededKanas.count))
                                    .foregroundStyle(.green)
                            }

                            if result.skippedKanas.count != 0 {
                                Text(.passed(result.skippedKanas.count))
                                    .foregroundStyle(.secondary)
                            }

                            if result.failedKanas.count != 0 {
                                Text(.incorrect(result.failedKanas.count))
                                    .foregroundStyle(.red)
                            }

                            if isPerfect {
                                DancingKaomojiView()
                            }
                        }
                    }.frame(maxWidth: .infinity)
                } header: {
                    Text(.completed)
                        .typography(.headline)
                        .padding()
                }

                Section {
                    Button(action: onTryAgainTapped) {
                        ZStack(alignment: .bottom) {
                            Image(._TrainingBanner.allInARow)
                                .resizable()
                                .scaledToFit()

                            HStack {
                                Spacer()
                                Text(.tryAgainWithSelection)
                                    .typography(.headline)
                                    .bold()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundStyle(.white)
                            .padding()
                            .background {
                                Color(white: 0)
                                    .opacity(0.7)
                            }
                        }
                        .cornerRadius(.default)
                    }.buttonStyle(.plain)

                    Button(action: onLevelUpsTapped) {
                        ZStack(alignment: .bottom) {
                            Image(._TrainingBanner.levelUp)
                                .resizable()
                                .scaledToFit()

                            HStack {
                                Spacer()
                                Text(.levelUps)
                                    .typography(.headline)
                                    .bold()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundStyle(.white)
                            .padding()
                            .background {
                                Color(white: 0)
                                    .opacity(0.7)
                            }
                        }
                        .cornerRadius(.default)
                    }.buttonStyle(.plain)

                    Button(.goBackToSelection, systemImage: "arrow.backward", action: onGoBackTapped)
                        .buttonStyle(.bordered)

                } header: {
                    Text(.navigate)
                }
            }

            if isPerfect {
                ConfettiView(count: 100, emitPoint: .init(x: UIScreen.main.bounds.width / 2, y: 0))
            }
        }
        .animation(.default, value: shouldShowRomajiForFailedKanas)
        .onAppear {
            guard displayedKanas.isEmpty else { return }
            startAnimation()
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

    func startAnimation() {
        animationTask?.cancel()
        animationTask = Task { @MainActor in
            displayedKanas = []

            for kana in result.allKanas {
                if Task.isCancelled { return }

                try? await Task.sleep(for: .seconds(0.1))
                if Task.isCancelled { return }

                withAnimation(.spring(duration: 0.3)) {
                    displayedKanas.append(kana)
                }
            }
        }
    }

    func skipAnimation() {
        animationTask?.cancel()
        animationTask = nil

        withAnimation(.easeOut(duration: 0.2)) {
            displayedKanas = result.allKanas
        }
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
