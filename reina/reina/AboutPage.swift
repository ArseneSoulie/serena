import SwiftUI

struct AboutPage: View {
    var body: some View {
        List {
            Section {
                Text(.aboutDetails)
            }
        }.navigationTitle(.about)
    }
}
