enum KanaSelectionType: String, CaseIterable, Hashable {
    case hiragana = "Hiragana"
    case both = "Both"
    case katakana = "Katakana"
    
    var symbol: String {
        switch self {
        case .hiragana: "あ"
        case .katakana: "ア"
        case .both: "&"
        }
    }
}

