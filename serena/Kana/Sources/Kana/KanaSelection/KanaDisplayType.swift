import SwiftUI

extension String {
    func format(_ type: TextType) -> String {
        switch type {
        case .hiragana: self.romajiToHiragana
        case .katakana: self.romajiToKatakana
        case .mixedOrOther: self
        }
    }
    
    #warning("""
    This is a very crude implementation of converting mixed text to romaji.
    In the future change this to a per kana transformation and move it to text transforms
    """)
    var formatAsRomaji: String {
        switch kanaType {
        case .hiragana: self.hiraganaToRomaji.lowercased()
        case .katakana: self.katakanaToRomaji.uppercased()
        case .mixedOrOther: self
        }
    }
}


enum TextType {
    case hiragana
    case katakana
    case mixedOrOther
}

extension String {
    var kanaType: TextType {
        var hasHiragana = false
        var hasKatakana = false
        var hasOther = false

        for scalar in self.unicodeScalars {
            let value = scalar.value
            switch value {
            case 0x3040...0x309F:
                hasHiragana = true
            case 0x30A0...0x30FF, 0x31F0...0x31FF:
                hasKatakana = true
            case 0x3000 where scalar == " ":
                continue // allow space (optional)
            default:
                hasOther = true
            }
        }

        switch (hasHiragana, hasKatakana, hasOther) {
        case (true, false, false): return .hiragana
        case (false, true, false): return .katakana
        case (_, _, true): return .mixedOrOther
        default: return .mixedOrOther
        }
    }
}
import CoreFoundation
