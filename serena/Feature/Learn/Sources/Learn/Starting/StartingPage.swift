import DesignSystem
import SwiftUI

public struct StartingPage: View {
    public init() {}

    public var body: some View {
        List {
            Section {
                Text("I'm new, where do I start?")
                Text("Wait, there are multiple alphabets?")
                Text("What are Hiragana?")
                Text("What are Katakana?")
                Text("Where did this writing system come from?")
                Text("How can I learn Japanese?")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Starting")
    }
}

#Preview {
    NavigationView {
        StartingPage()
    }
}
