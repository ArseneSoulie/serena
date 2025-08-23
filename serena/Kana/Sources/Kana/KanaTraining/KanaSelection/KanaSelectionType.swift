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

    var localisedDescription: String {
        switch self {
        case .hiragana:
            localized("Hiragana")
        case .both:
            localized("Both")
        case .katakana:
            localized("Katakana")
        }
    }
}
