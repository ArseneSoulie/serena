import SwiftUI

public struct LearnMainPage: View {
    public init() {}

    public var body: some View {
        List {
            Section {
                Text("Hello, World!")
            }
        }.navigationTitle(.learn)
    }
}

#Preview {
    NavigationView {
        LearnMainPage()
    }
}
