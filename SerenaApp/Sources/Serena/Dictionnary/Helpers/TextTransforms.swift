import Foundation

extension String {
    var asKatanana: String {
        self.applyingTransform(.hiraganaToKatakana, reverse: false) ?? self
    }
    
    var asHiragana: String {
        self.applyingTransform(.hiraganaToKatakana, reverse: true) ?? self
    }
}
