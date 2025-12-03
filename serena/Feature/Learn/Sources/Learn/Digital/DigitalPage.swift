import DesignSystem
import SwiftUI

public struct DigitalPage: View {
    public init() {}

    public var body: some View {
        List {
            Section {
                Text("What is 'Romaji'?")
                Text("How do I look things up in a dictionary?")
                Text("How do I type Japanese on my phone?")
                Text("How do I type on a computer?")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Digital Japanese")
    }
}

#Preview {
    NavigationView {
        DigitalPage()
    }
}
