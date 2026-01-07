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

    @State private var displayedKanas: Set<Kana> = []
    @State private var shouldShowRomajiForFailedKanas: Bool = false

    @State private var animationTask: Task<Void, Never>?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text(.completed)
                    .typography(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                VStack {
                    let columns = [GridItem(.adaptive(minimum: 50))]
                    LazyVGrid(columns: columns) {
                        ForEach(result.succeededKanas, id: \.kanaValue) { successKana in
                            ResultTileView(kana: successKana, backgroundColor: .green, shouldShowRomaji: false)
                                .opacity(displayedKanas.contains(successKana) ? 1 : 0)
                        }
                        ForEach(result.skippedKanas, id: \.kanaValue) { skippedKana in
                            ResultTileView(kana: skippedKana, backgroundColor: .gray, shouldShowRomaji: false)
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
                    }.padding(.bottom)

                    Divider()

                    if isPerfect {
                        Text(.perfectRun🎉)
                    } else {
                        HStack {
                            if !result.succeededKanas.isEmpty {
                                Text(.correct(result.succeededKanas.count))
                                    .foregroundStyle(.green)
                            }

                            if !result.skippedKanas.isEmpty {
                                Text(.passed(result.skippedKanas.count))
                                    .foregroundStyle(.secondary)
                            }

                            if !result.failedKanas.isEmpty {
                                Text(.incorrect(result.failedKanas.count))
                                    .foregroundStyle(.red)
                            }
                        }

                        if isPerfect {
                            DancingKaomojiView()
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(.default)
                .onTapGesture {
                    skipAnimation()
                }

                VStack(spacing: 16) {
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
                                Color(white: 0).opacity(0.7)
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
                                Color(white: 0).opacity(0.7)
                            }
                        }
                        .cornerRadius(.default)
                    }.buttonStyle(.plain)

                    Button(.goBackToSelection, systemImage: "arrow.backward", action: onGoBackTapped)
                        .buttonStyle(.bordered)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(.default)
            }
            .padding()
        }

        .overlay {
            if isPerfect {
                ConfettiView(count: 100, emitPoint: .init(x: UIScreen.main.bounds.width / 2, y: 0))
            }
        }
        .background(Color(uiColor: UIColor.systemGroupedBackground))
        .animation(.default, value: shouldShowRomajiForFailedKanas)
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            animationTask?.cancel()
        }
        .toolbar {
            if !result.failedKanas.isEmpty {
                Toggle(isOn: $shouldShowRomajiForFailedKanas) {
                    Text(.showRomajiForFailed)
                }.padding()
            }
        }
    }

    var isPerfect: Bool {
        result.failedKanas.count == 0 && result.skippedKanas.count == 0
    }

    // MARK: - Animation Logic

    func startAnimation() {
        guard displayedKanas.isEmpty else { return }

        animationTask?.cancel()

        animationTask = Task { @MainActor in
            displayedKanas = []
            let allKanas = result.allKanas

            for kana in allKanas {
                if Task.isCancelled { return }

                try? await Task.sleep(for: .seconds(0.1))

                if Task.isCancelled { return }

                withAnimation(.spring(duration: 0.3)) {
                    _ = displayedKanas.insert(kana)
                }
            }
        }
    }

    func skipAnimation() {
        guard let task = animationTask, !task.isCancelled else { return }

        task.cancel()
        animationTask = nil

        withAnimation(.easeOut(duration: 0.2)) {
            displayedKanas = Set(result.allKanas)
        }
    }
}

struct ResultTileView: View {
    let kana: Kana
    let backgroundColor: Color
    let shouldShowRomaji: Bool

    var body: some View {
        VStack {
            Text(kana.kanaValue)
                .typography(.title)
            if shouldShowRomaji {
                Text(kana.romajiValue)
                    .typography(.callout)
            }
        }
        .foregroundStyle(.white)
        .padding(.all, 8)
        .background {
            RoundedRectangle(cornerRadius: 4)
                .fill(backgroundColor)
                .brightness(-0.2)
                .offset(x: 0, y: 4)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(backgroundColor.gradient)
                })
        }
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

#Preview {
    ResultTileView(
        kana: .hiragana(value: "か"),
        backgroundColor: .red,
        shouldShowRomaji: true,
    )
}
