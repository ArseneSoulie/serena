import Foundation
import FoundationModels

struct KanaMnemonicData: Identifiable, Hashable {
    let id: UUID = .init()
    let unicodeID: String
    let kanaString: String
    let explanation: String
}

extension KanaType {
    var mnemonicsData: [KanaMnemonicData] {
        switch self {
        case .hiragana: hiraganaMnemonicsData
        case .katakana: katakanaMnemonicsData
        }
    }
}

let hiraganaMnemonicsData: [KanaMnemonicData] = [
    .init(unicodeID: "3042", kanaString: "あ", explanation: "bla"),
    .init(unicodeID: "3044", kanaString: "い", explanation: "bla"),
    .init(unicodeID: "3046", kanaString: "う", explanation: "bla"),
    .init(unicodeID: "3048", kanaString: "え", explanation: "bla"),
    .init(unicodeID: "304a", kanaString: "お", explanation: "bla"),
    .init(unicodeID: "304b", kanaString: "か", explanation: "bla"),
    .init(unicodeID: "304d", kanaString: "き", explanation: "bla"),
    .init(unicodeID: "304f", kanaString: "く", explanation: "bla"),
    .init(unicodeID: "3051", kanaString: "け", explanation: "bla"),
    .init(unicodeID: "3053", kanaString: "こ", explanation: "bla"),
    .init(unicodeID: "3055", kanaString: "さ", explanation: "bla"),
    .init(unicodeID: "3057", kanaString: "し", explanation: "bla"),
    .init(unicodeID: "3059", kanaString: "す", explanation: "bla"),
    .init(unicodeID: "305b", kanaString: "せ", explanation: "bla"),
    .init(unicodeID: "305d", kanaString: "そ", explanation: "bla"),
    .init(unicodeID: "305f", kanaString: "た", explanation: "bla"),
    .init(unicodeID: "3061", kanaString: "ち", explanation: "bla"),
    .init(unicodeID: "3064", kanaString: "つ", explanation: "bla"),
    .init(unicodeID: "3066", kanaString: "て", explanation: "bla"),
    .init(unicodeID: "3068", kanaString: "と", explanation: "bla"),
    .init(unicodeID: "306a", kanaString: "な", explanation: "bla"),
    .init(unicodeID: "306b", kanaString: "に", explanation: "bla"),
    .init(unicodeID: "306c", kanaString: "ぬ", explanation: "bla"),
    .init(unicodeID: "306d", kanaString: "ね", explanation: "bla"),
    .init(unicodeID: "306e", kanaString: "の", explanation: "bla"),
    .init(unicodeID: "306f", kanaString: "は", explanation: "bla"),
    .init(unicodeID: "3072", kanaString: "ひ", explanation: "bla"),
    .init(unicodeID: "3075", kanaString: "ふ", explanation: "bla"),
    .init(unicodeID: "3078", kanaString: "へ", explanation: "bla"),
    .init(unicodeID: "307b", kanaString: "ほ", explanation: "bla"),
    .init(unicodeID: "307e", kanaString: "ま", explanation: "bla"),
    .init(unicodeID: "307f", kanaString: "み", explanation: "bla"),
    .init(unicodeID: "3080", kanaString: "む", explanation: "bla"),
    .init(unicodeID: "3081", kanaString: "め", explanation: "bla"),
    .init(unicodeID: "3082", kanaString: "も", explanation: "bla"),
    .init(unicodeID: "3084", kanaString: "や", explanation: "bla"),
    .init(unicodeID: "3086", kanaString: "ゆ", explanation: "bla"),
    .init(unicodeID: "3088", kanaString: "よ", explanation: "bla"),
    .init(unicodeID: "3089", kanaString: "ら", explanation: "bla"),
    .init(unicodeID: "308a", kanaString: "り", explanation: "bla"),
    .init(unicodeID: "308b", kanaString: "る", explanation: "bla"),
    .init(unicodeID: "308c", kanaString: "れ", explanation: "bla"),
    .init(unicodeID: "308d", kanaString: "ろ", explanation: "bla"),
    .init(unicodeID: "308f", kanaString: "わ", explanation: "bla"),
    .init(unicodeID: "3092", kanaString: "を", explanation: "bla"),
    .init(unicodeID: "3093", kanaString: "ん", explanation: "bla"),
]

let katakanaMnemonicsData: [KanaMnemonicData] = [
    .init(unicodeID: "30a2", kanaString: "ア", explanation: "bla"),
    .init(unicodeID: "30a4", kanaString: "イ", explanation: "bla"),
    .init(unicodeID: "30a6", kanaString: "ウ", explanation: "bla"),
    .init(unicodeID: "30a8", kanaString: "エ", explanation: "bla"),
    .init(unicodeID: "30aa", kanaString: "オ", explanation: "bla"),
    .init(unicodeID: "30ab", kanaString: "カ", explanation: "bla"),
    .init(unicodeID: "30ad", kanaString: "キ", explanation: "bla"),
    .init(unicodeID: "30af", kanaString: "ク", explanation: "bla"),
    .init(unicodeID: "30b1", kanaString: "ケ", explanation: "bla"),
    .init(unicodeID: "30b3", kanaString: "コ", explanation: "bla"),
    .init(unicodeID: "30b5", kanaString: "サ", explanation: "bla"),
    .init(unicodeID: "30b7", kanaString: "シ", explanation: "bla"),
    .init(unicodeID: "30b9", kanaString: "ス", explanation: "bla"),
    .init(unicodeID: "30bb", kanaString: "セ", explanation: "bla"),
    .init(unicodeID: "30bd", kanaString: "ソ", explanation: "bla"),
    .init(unicodeID: "30bf", kanaString: "タ", explanation: "bla"),
    .init(unicodeID: "30c1", kanaString: "チ", explanation: "bla"),
    .init(unicodeID: "30c4", kanaString: "ツ", explanation: "bla"),
    .init(unicodeID: "30c6", kanaString: "テ", explanation: "bla"),
    .init(unicodeID: "30c8", kanaString: "ト", explanation: "bla"),
    .init(unicodeID: "30ca", kanaString: "ナ", explanation: "bla"),
    .init(unicodeID: "30cb", kanaString: "ニ", explanation: "bla"),
    .init(unicodeID: "30cc", kanaString: "ヌ", explanation: "bla"),
    .init(unicodeID: "30cd", kanaString: "ネ", explanation: "bla"),
    .init(unicodeID: "30ce", kanaString: "ノ", explanation: "bla"),
    .init(unicodeID: "30cf", kanaString: "ハ", explanation: "bla"),
    .init(unicodeID: "30d2", kanaString: "ヒ", explanation: "bla"),
    .init(unicodeID: "30d5", kanaString: "フ", explanation: "bla"),
    .init(unicodeID: "30d8", kanaString: "ヘ", explanation: "bla"),
    .init(unicodeID: "30db", kanaString: "ホ", explanation: "bla"),
    .init(unicodeID: "30de", kanaString: "マ", explanation: "bla"),
    .init(unicodeID: "30df", kanaString: "ミ", explanation: "bla"),
    .init(unicodeID: "30e0", kanaString: "ム", explanation: "bla"),
    .init(unicodeID: "30e1", kanaString: "メ", explanation: "bla"),
    .init(unicodeID: "30e2", kanaString: "モ", explanation: "bla"),
    .init(unicodeID: "30e4", kanaString: "ヤ", explanation: "bla"),
    .init(unicodeID: "30e6", kanaString: "ユ", explanation: "bla"),
    .init(unicodeID: "30e8", kanaString: "ヨ", explanation: "bla"),
    .init(unicodeID: "30e9", kanaString: "ラ", explanation: "bla"),
    .init(unicodeID: "30ea", kanaString: "リ", explanation: "bla"),
    .init(unicodeID: "30eb", kanaString: "ル", explanation: "bla"),
    .init(unicodeID: "30ec", kanaString: "レ", explanation: "bla"),
    .init(unicodeID: "30ed", kanaString: "ロ", explanation: "bla"),
    .init(unicodeID: "30ef", kanaString: "ワ", explanation: "bla"),
    .init(unicodeID: "30f2", kanaString: "ヲ", explanation: "bla"),
    .init(unicodeID: "30f3", kanaString: "ン", explanation: "bla"),
]
