import SwiftUI

struct OnyomiTextView: View {
    let text: String
    @Environment(\.useKatakanaForOnyomi) var useKatakanaForOnyomi
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(useKatakanaForOnyomi ? text.asKatakana : text.asHiragana)
    }
}
