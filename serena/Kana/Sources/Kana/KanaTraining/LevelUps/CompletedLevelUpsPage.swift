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
                        Text(.completed)
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
                    Button(.tryAgainWithSelection, action: onTryAgainTapped)
                    Button(.allInARow, action: onAllInARowTapped)
                }.buttonStyle(.borderedProminent)
                    .padding()
                Button(.goBackToSelection, action: onGoBackTapped)
                    .buttonStyle(.borderless)
            }.padding()
            ConfettiView(count: 100, emitPoint: .init(x: UIScreen.main.bounds.width / 2, y: 0))
        }
    }
}
