import SwiftUI

struct CompletedPage: View {
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
            
            TimelineView(.periodic(from: .now, by: 1)) { context in
                let date = context.date
                let seconds = Calendar.current.component(.second, from: date)
                if seconds % 2 == 0 {
                    Text("└[∵┌] ヾ(-_- )ゞ [┐∵]┘").font(.title2)
                } else {
                    Text("┌[∵└] ノ( -_-)ノ [┘∵]┐").font(.title2)
                }
            }
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
