import SwiftUI

struct TextWithHighlight: View {
    let fullText: String
    let textToMatch: String

    var body: some View {
        if let range = firstMatchedRange {
            let before = String(fullText[..<range.lowerBound])
            let match = String(fullText[range])
            let after = String(fullText[range.upperBound...])

            return Text(before) + Text(match).bold().foregroundStyle(isFullMatch ? .green : .blue) + Text(after)
        } else {
            return Text(fullText)
        }
    }

    var firstMatchedRange: Range<String.Index>? {
        var textToMatch = textToMatch

        var range: Range<String.Index>?

        while !textToMatch.isEmpty, range == nil {
            range = fullText.range(of: textToMatch, options: [.caseInsensitive, .widthInsensitive])

            if !textToMatch.isEmpty { textToMatch.removeLast() }
        }

        return range
    }

    var isFullMatch: Bool {
        fullText == textToMatch
    }
}
