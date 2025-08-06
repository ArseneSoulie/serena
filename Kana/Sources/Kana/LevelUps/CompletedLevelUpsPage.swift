import SwiftUI

struct CompletedLevelUpsPage: View {
    let onTryAgainTapped: () -> Void
    let onAllInARowTapped: () -> Void
    let onGoBackTapped: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text(.completed)
                    .font(.headline)
                Image(systemName: "party.popper")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .padding()
                Text("おめでとう").font(.title2)
                
                Spacer()
                
                DancingKaomojiView()
                HStack {
                    Button(.tryAgainWithSelection, action: onTryAgainTapped)
                    Button(.allInARow, action: onAllInARowTapped)
                }.buttonStyle(.borderedProminent)
                    .padding()
                Button(.goBackToSelection, action: onGoBackTapped)
                    .buttonStyle(.borderless)
            }
            ConfettiView(count: 100, emitPoint: .init(x: UIScreen.main.bounds.width/2, y: 0))
        }
    }
}
