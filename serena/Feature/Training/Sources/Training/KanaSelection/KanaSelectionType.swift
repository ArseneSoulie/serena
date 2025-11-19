import Foundation

enum KanaSelectionType: CaseIterable, Hashable {
    case hiragana
    case both
    case katakana

    var symbol: String {
        switch self {
        case .hiragana: "あ"
        case .katakana: "ア"
        case .both: "&"
        }
    }

    var localisedDescription: LocalizedStringResource {
        switch self {
        case .hiragana:
            .hiragana
        case .both:
            .both
        case .katakana:
            .katakana
        }
    }
}
