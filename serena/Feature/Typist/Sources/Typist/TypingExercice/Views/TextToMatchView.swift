import DesignSystem
import SwiftUI

struct TextToMatchData: Equatable {
    let reading: String
    let writing: String?
    let textToMatch: String

    var mainText: String {
        writing ?? reading
    }

    var secondaryText: String? {
        writing != nil ? reading : nil
    }
}

struct TextToMatchView: View {
    let data: TextToMatchData
    var body: some View {
        VStack {
            if let secondaryText = data.secondaryText {
                TextWithHighlight(fullText: secondaryText, textToMatch: data.textToMatch)
                    .textWithHighlightStyle(.secondary)
            }
            TextWithHighlight(fullText: data.mainText, textToMatch: data.textToMatch)
                .typography(.title2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .background(.thickMaterial, in: Capsule())
        .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    TextToMatchView(
        data: .init(
            reading: "おちゃ",
            writing: "お茶",
            textToMatch: "お",
        ),
    )
}
