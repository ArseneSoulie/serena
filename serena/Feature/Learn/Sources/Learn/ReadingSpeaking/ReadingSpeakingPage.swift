import DesignSystem
import SwiftUI

public struct ReadingSpeakingPage: View {
    public init() {}

    public var body: some View {
        List {
            Section {
                Text("What are the two little dashes ゛? (Dakuten)")
                Text("What are the little circles ゜? (Handakuten)")
                Text("What is a 'Mora' (Rhythm)?")
                Text("Why is this character so small? (っ, ゃ, ゅ, ょ)")
                Text("How do I make long sounds? (Prolongations)")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Reading & Speaking")
    }
}

#Preview {
    NavigationView {
        ReadingSpeakingPage()
    }
}
