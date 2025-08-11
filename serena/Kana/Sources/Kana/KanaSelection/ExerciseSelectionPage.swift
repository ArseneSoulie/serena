//
//  ExerciseSelectionPage.swift
//  Kana
//
//  Created by A S on 11/08/2025.
//

import SwiftUI
import Navigation

public struct ExerciseSelectionPage: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    
    let kanaPool: [String]
    
    public init(kanaPool: [String]) {
        self.kanaPool = kanaPool
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(localized("Level ups")).font(.title)
            Text(localized("Test your knowledge on 10 random kanas chosen from the selection with increasing difficulty."))
            Button(localized("Go !"), action:onLevelUpsTapped )
                .buttonStyle(.bordered)
            Divider().padding()
            Text(localized("All in a row")).font(.title)
            Text(localized("Try to get all selected kanas right in a row !"))
            Button(localized("Go !"), action:onAllInARowTapped )
                .buttonStyle(.bordered)
        }.padding()
//        .navigationTitle("Pick an exercise type")
    }
    
    func onLevelUpsTapped() {
        coordinator.push(.levelUps(kanaPool))
    }
    
    func onAllInARowTapped() {
        coordinator.push(.allInARow(kanaPool))
    }
    
}


#Preview {
    ExerciseSelectionPage(kanaPool: [])
        .environment(NavigationCoordinator())
}
