public enum Kana: Hashable, Equatable, Sendable {
    case hiragana(value: String)
    case katakana(value: String)
    
    public var kanaValue: String {
        switch self {
        case .hiragana(let value):
            value.romajiToHiragana.lowercased()
        case .katakana(let value):
            value.romajiToKatakana.uppercased()
        }
    }
    
    public var romajiValue: String {
        switch self {
        case .hiragana(let value):
            value.hiraganaToRomaji
        case .katakana(let value):
            value.katakanaToRomaji
        }
    }
}
