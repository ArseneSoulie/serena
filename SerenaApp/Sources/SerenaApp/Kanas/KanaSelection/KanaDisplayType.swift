import SwiftUI

enum KanaDisplayType {
    case asHiragana
    case asKatakana
    case asLowercasedRomaji
    case asUppercasedRomaji
}


extension EnvironmentValues {
    @Entry var kanaDisplayType: KanaDisplayType = .asHiragana
}

extension String {
    func format(_ displayType: KanaDisplayType) -> String {
        switch displayType {
        case .asHiragana: self.romajiToHiragana
        case .asKatakana: self.romajiToKatakana
        case .asLowercasedRomaji: self.hiraganaToRomaji
        case .asUppercasedRomaji: self.katakanaToRomaji
        }
    }
    
    func format(_ type: KanaType) -> String {
        switch type {
        case .hiragana: format(.asHiragana)
        case .katakana: format(.asKatakana)
        }
    }
    
    func formatAsRomaji(_ type: KanaType) -> String {
        switch type {
        case .hiragana: format(.asLowercasedRomaji)
        case .katakana: format(.asUppercasedRomaji)
        }
    }
}
