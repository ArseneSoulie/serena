import DesignSystem
import SwiftUI

public struct TextWithHighlight: View {
    @Environment(\.textWithHighlightStyle) var style

    let fullText: String
    let textToMatch: String

    public var body: some View {
        Group {
            if let range = firstMatchedRange {
                let before = String(fullText[..<range.lowerBound])
                let match = String(fullText[range])
                let after = String(fullText[range.upperBound...])

                return Text(before) +
                    Text(match).bold().foregroundStyle(isFullMatch ? .green : style.highlightColor) +
                    Text(after)
            } else {
                return Text(fullText)
            }
        }.typography(style.typography)
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

public extension TextWithHighlight {
    enum Style: Sendable {
        case main
        case secondary

        var typography: Typography {
            switch self {
            case .main: .title2
            case .secondary: .caption
            }
        }

        var highlightColor: Color {
            switch self {
            case .main: .blue
            case .secondary: .cyan
            }
        }

        public static let `default`: Self = .main
    }
}

public extension View {
    func textWithHighlightStyle(_ style: TextWithHighlight.Style) -> some View {
        modifier(TextWithHighlightStyleModifier(style: style))
    }
}

private struct TextWithHighlightStyleModifier: ViewModifier {
    let style: TextWithHighlight.Style

    func body(content: Content) -> some View {
        content
            .environment(\.textWithHighlightStyle, style)
    }
}

extension EnvironmentValues {
    @Entry var textWithHighlightStyle: TextWithHighlight.Style = .default
}
