enum KanaType: String, CaseIterable, Hashable {
    case hiragana = "Hiragana"
    case katakana = "Katakana"
    
    var letter: String {
        switch self {
        case .hiragana: "あ"
        case .katakana: "ア"
        }
    }
    
    var romajiLetter: String {
        switch self {
        case .hiragana: "a"
        case .katakana: "A"
        }
    }
}
