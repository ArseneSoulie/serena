import SwiftUI

struct CompletedLevelUpsPage: View {
    let onTryAgainTapped: () -> Void
    let onAllInARowTapped: () -> Void
    let onGoBackTapped: () -> Void

    var body: some View {
        ZStack {
            List {
                Section {
                    VStack {
                        Image(systemName: "party.popper")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .padding()
                        DancingKaomojiView()
                    }.frame(maxWidth: .infinity)
                } header: {
                    Text(.completed)
                        .typography(.headline)
                }

                Section {
                    Button(action: onTryAgainTapped) {
                        ZStack(alignment: .bottom) {
                            Image(._TrainingBanner.levelUp)
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

                    Button(action: onAllInARowTapped) {
                        ZStack(alignment: .bottom) {
                            Image(._TrainingBanner.allInARow)
                                .resizable()
                                .scaledToFit()

                            HStack {
                                Spacer()
                                Text(.allInARow)
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
