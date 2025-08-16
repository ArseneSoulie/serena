public enum Kana: Hashable, Equatable, Sendable {
    case hiragana(value: String)
    case katakana(value: String)

    public var kanaValue: String {
        switch self {
        case let .hiragana(value):
            value.romajiToHiragana.lowercased()
        case let .katakana(value):
            value.romajiToKatakana.uppercased()
        }
    }

    public var romajiValue: String {
        switch self {
        case let .hiragana(value):
            value.hiraganaToRomaji
        case let .katakana(value):
            value.katakanaToRomaji
        }
    }
}
