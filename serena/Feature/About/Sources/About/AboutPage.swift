import SwiftUI

public struct AboutPage: View {
    public init() {}

    public var body: some View {
        List {
            Section {
                Text(.aboutDetails)
            }
        }.navigationTitle(.about)
    }
}
