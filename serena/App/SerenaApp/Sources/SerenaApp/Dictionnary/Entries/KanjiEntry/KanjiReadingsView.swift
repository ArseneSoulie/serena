import SwiftUI

struct KanjiReadingsView: View {
    let title: String
    let readings: [String]

    var body: some View {
        HStack {
            Text(title).foregroundStyle(.secondary)
            if readings.count == 0 {
                Text("-").foregroundStyle(.secondary)
            }
            OnyomiTextView(readings.joined(separator: ", "))
        }
    }
}
