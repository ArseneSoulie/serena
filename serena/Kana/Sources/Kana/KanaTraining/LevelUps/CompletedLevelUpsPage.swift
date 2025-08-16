import SwiftUI

struct CompletedLevelUpsPage: View {
    let onTryAgainTapped: () -> Void
    let onAllInARowTapped: () -> Void
    let onGoBackTapped: () -> Void

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack {
                        Text(localized("Completed !"))
                            .typography(.headline)
                        Spacer()
                        Image(systemName: "party.popper")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .padding()
                        DancingKaomojiView()

                        Spacer()
                    }
                }
                HStack {
                    Button(localized("Try again with selection"), action: onTryAgainTapped)
                    Button(localized("All in a row"), action: onAllInARowTapped)
                }.buttonStyle(.borderedProminent)
                    .padding()
                Button(localized("Go back to selection"), action: onGoBackTapped)
                    .buttonStyle(.borderless)
            }.padding()
            ConfettiView(count: 100, emitPoint: .init(x: UIScreen.main.bounds.width / 2, y: 0))
        }
    }
}
