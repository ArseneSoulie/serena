import SwiftUI

struct CompletedLevelUpsPage: View {
    let onTryAgainTapped: () -> Void
    let onAllInARowTapped: () -> Void
    let onGoBackTapped: () -> Void

    var body: some View {
        ScrollView {
            VStack {
                Text(.completed)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .typography(.title2)
                    .padding(.horizontal)
                    .padding(.top)

                Image(._ReinaEmotes.party)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .padding()

                DancingKaomojiView()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(.default)

                VStack(spacing: 16) {
                    ExerciceRedirectionBannerView(
                        image: ._TrainingBanner.levelUp,
                        label: .tryAgainWithSelection,
                        onBannerTapped: onTryAgainTapped,
                    )

                    ExerciceRedirectionBannerView(
                        image: ._TrainingBanner.allInARow,
                        label: .allInARow,
                        onBannerTapped: onAllInARowTapped,
                    )
                    Button(.goBackToSelection, systemImage: "arrow.backward", action: onGoBackTapped)
                        .buttonStyle(.bordered)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(.default)
            }.padding(.horizontal)
        }
        .background(Color(uiColor: UIColor.systemGroupedBackground))
        .overlay {
            ConfettiView(count: 100, emitPoint: .init(x: UIScreen.main.bounds.width / 2, y: 0))
        }
    }
}

#Preview {
    CompletedLevelUpsPage(
        onTryAgainTapped: {},
        onAllInARowTapped: {},
        onGoBackTapped: {},
    )
}
