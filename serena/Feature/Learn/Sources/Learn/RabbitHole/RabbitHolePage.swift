import DesignSystem
import SwiftUI

public struct RabbitHolePage: View {
    public init() {}

    public var body: some View {
        List {
            Section {
                Text("Did you say cursive?")
                Text("What are Hentaigana?")
                Text("Where did We and Wi go?")
                Text("Why is 'Vertical Writing' a thing?")
                Text("The 'Cursed' Inputs (Typing UXO for ウォ)")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("The Rabbit Hole")
    }
}

#Preview {
    NavigationView {
        RabbitHolePage()
    }
}
