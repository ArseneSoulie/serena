import SwiftUI

struct CompletedLevelUpsPage: View {
    let onTryAgainTapped: () -> Void
    let onAllInARowTapped: () -> Void
    let onGoBackTapped: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Completed !")
                .font(.headline)
            Image(systemName: "party.popper")
                .resizable()
                .frame(width: 80, height: 80)
                .padding()
            Text("おめでとう").font(.title2)
            
            Spacer()
            
            DancingKaomojiView()
            HStack {
                Button("Try again with selection", action: onTryAgainTapped)
                Button("All in a row", action: onAllInARowTapped)
            }.buttonStyle(.borderedProminent)
                .padding()
            Button("Go back to selection", action: onGoBackTapped)
                .buttonStyle(.borderless)
        }
    }
}
