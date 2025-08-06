import SwiftUI
import DesignSystem

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
    let kanaText: String
    let completionState: CompletionState
    
    var id: String { kanaText }
}

struct CompletedAllInARowPage: View {
    let kanas: [String]
    let kanaType: KanaType
    
    let failedKanas: Set<String>
    let remainingKanas: Set<String>
    
    let onTryAgainTapped: () -> Void
    let onLevelUpsTapped: () -> Void
    let onGoBackTapped: () -> Void
    
    @State var tiles: [CompletedTileData] = []
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack {
                        Text(.completed)
                            .font(.headline)
                            .padding()
                        Text(completionText)
                            .font(.subheadline)
                        let columns = [GridItem(.adaptive(minimum: 50))]
                        
                        LazyVGrid(columns: columns) {
                            ForEach(tiles) {
                                Button($0.kanaText) {}
                                    .buttonStyle(TileButtonStyle(tileSize: .largeEntry, tileKind: .custom($0.completionState.color)))
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
                    Button(.tryAgainWithSelection, action: onTryAgainTapped)
                    Button(.levelUps, action: onLevelUpsTapped)
                }.buttonStyle(.borderedProminent)
                    .padding()
                Button(.goBackToSelection, action: onGoBackTapped)
                    .buttonStyle(.borderless)
            }
            if isPerfect {
                ConfettiView(count: 100, emitPoint: .init(x: UIScreen.main.bounds.width/2, y: 0))
            }
        }
        .onAppear {
            guard tiles.isEmpty else { return }
            Task {
                for kana in kanas {
                    try? await Task.sleep(for: .seconds(0.1))
                    withAnimation {
                        tiles.append(.init(kanaText: kana.format(kanaType), completionState: completionState(for: kana))
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
            return localized(.perfectRun🎉)
        } else {
            let failedText = failedKanas.isEmpty ? "" : "\(localized(.incorrect)): \(failedKanas.count) "
            let skippedText = remainingKanas.isEmpty ? "" : "\(localized(.passed)): \(remainingKanas.count) "
            let succeededText = "\(localized(.correct)): \(kanas.count - (remainingKanas.count + failedKanas.count)) "
            
            return succeededText + failedText + skippedText
        }
    }
    
    func completionState(for kana: String) -> CompletionState {
        if failedKanas.contains(kana) { .failed }
        else if remainingKanas.contains(kana) { .skipped }
        else { .success }
    }
}



#Preview {
    CompletedAllInARowPage(
        kanas: ["a", "i", "u", "e", "o", "ka", "ki", "ku"],
        kanaType: .hiragana,
        failedKanas: ["ka"],
        remainingKanas: [],
        onTryAgainTapped: { },
        onLevelUpsTapped: { },
        onGoBackTapped: { }
    )
}
