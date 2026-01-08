import DesignSystem
import SwiftUI

public struct GrammarPage: View {
    public init() {}

    public var body: some View {
        List {
            Section {
                Text("What are Particles?")
                Text("Why is は pronounced 'Wa'?")
                Text("Why is を pronounced 'O'?")
                Text("Why is へ pronounced 'E'?")
                Text("Let's break down a sentence")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Grammar & Particles")
    }
}

#Preview {
    NavigationView {
        GrammarPage()
    }
}
