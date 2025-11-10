import SwiftUI

struct AboutPage: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(.aboutDetails)
            }.padding()
        }.navigationTitle(.about)
    }
}
