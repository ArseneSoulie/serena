import Foundation
import FoundationModels

struct KanaMnemonicData: Identifiable, Hashable {
    let id: UUID = .init()
    let kanjivgId: String
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
    .init(kanjivgId: "03042", kanaString: "あ", explanation: "bla"),
    .init(kanjivgId: "03044", kanaString: "い", explanation: "bla"),
    .init(kanjivgId: "03046", kanaString: "う", explanation: "bla"),
    .init(kanjivgId: "03048", kanaString: "え", explanation: "bla"),
    .init(kanjivgId: "0304a", kanaString: "お", explanation: "bla"),
    .init(kanjivgId: "0304b", kanaString: "か", explanation: "bla"),
    .init(kanjivgId: "0304c", kanaString: "が", explanation: "bla"),
    .init(kanjivgId: "0304d", kanaString: "き", explanation: "bla"),
    .init(kanjivgId: "0304e", kanaString: "ぎ", explanation: "bla"),
    .init(kanjivgId: "0304f", kanaString: "く", explanation: "bla"),
    .init(kanjivgId: "03051", kanaString: "け", explanation: "bla"),
    .init(kanjivgId: "03053", kanaString: "こ", explanation: "bla"),
    .init(kanjivgId: "03055", kanaString: "さ", explanation: "bla"),
    .init(kanjivgId: "03057", kanaString: "し", explanation: "bla"),
    .init(kanjivgId: "03059", kanaString: "す", explanation: "bla"),
    .init(kanjivgId: "0305b", kanaString: "せ", explanation: "bla"),
    .init(kanjivgId: "0305d", kanaString: "そ", explanation: "bla"),
    .init(kanjivgId: "0305f", kanaString: "た", explanation: "bla"),
    .init(kanjivgId: "03061", kanaString: "ち", explanation: "bla"),
    .init(kanjivgId: "03064", kanaString: "つ", explanation: "bla"),
    .init(kanjivgId: "03066", kanaString: "て", explanation: "bla"),
    .init(kanjivgId: "03068", kanaString: "と", explanation: "bla"),
    .init(kanjivgId: "0306a", kanaString: "な", explanation: "bla"),
    .init(kanjivgId: "0306b", kanaString: "に", explanation: "bla"),
    .init(kanjivgId: "0306c", kanaString: "ぬ", explanation: "bla"),
    .init(kanjivgId: "0306d", kanaString: "ね", explanation: "bla"),
    .init(kanjivgId: "0306e", kanaString: "の", explanation: "bla"),
    .init(kanjivgId: "0306f", kanaString: "は", explanation: "bla"),
    .init(kanjivgId: "03072", kanaString: "ひ", explanation: "bla"),
    .init(kanjivgId: "03075", kanaString: "ふ", explanation: "bla"),
    .init(kanjivgId: "03078", kanaString: "へ", explanation: "bla"),
    .init(kanjivgId: "0307b", kanaString: "ほ", explanation: "bla"),
    .init(kanjivgId: "0307e", kanaString: "ま", explanation: "bla"),
    .init(kanjivgId: "0307f", kanaString: "み", explanation: "bla"),
    .init(kanjivgId: "03080", kanaString: "む", explanation: "bla"),
    .init(kanjivgId: "03081", kanaString: "め", explanation: "bla"),
    .init(kanjivgId: "03082", kanaString: "も", explanation: "bla"),
    .init(kanjivgId: "03084", kanaString: "や", explanation: "bla"),
    .init(kanjivgId: "03086", kanaString: "ゆ", explanation: "bla"),
    .init(kanjivgId: "03088", kanaString: "よ", explanation: "bla"),
    .init(kanjivgId: "03089", kanaString: "ら", explanation: "bla"),
    .init(kanjivgId: "0308a", kanaString: "り", explanation: "bla"),
    .init(kanjivgId: "0308b", kanaString: "る", explanation: "bla"),
    .init(kanjivgId: "0308c", kanaString: "れ", explanation: "bla"),
    .init(kanjivgId: "0308d", kanaString: "ろ", explanation: "bla"),
    .init(kanjivgId: "0308f", kanaString: "わ", explanation: "bla"),
    .init(kanjivgId: "03092", kanaString: "を", explanation: "bla"),
    .init(kanjivgId: "03093", kanaString: "ん", explanation: "bla"),
]

let katakanaMnemonicsData: [KanaMnemonicData] = [
    .init(kanjivgId: "030a2", kanaString: "ア", explanation: "bla"),
    .init(kanjivgId: "030a4", kanaString: "イ", explanation: "bla"),
    .init(kanjivgId: "030a6", kanaString: "ウ", explanation: "bla"),
    .init(kanjivgId: "030a8", kanaString: "エ", explanation: "bla"),
    .init(kanjivgId: "030aa", kanaString: "オ", explanation: "bla"),
    .init(kanjivgId: "030ab", kanaString: "カ", explanation: "bla"),
    .init(kanjivgId: "030ad", kanaString: "キ", explanation: "bla"),
    .init(kanjivgId: "030af", kanaString: "ク", explanation: "bla"),
    .init(kanjivgId: "030b1", kanaString: "ケ", explanation: "bla"),
    .init(kanjivgId: "030b3", kanaString: "コ", explanation: "bla"),
    .init(kanjivgId: "030b5", kanaString: "サ", explanation: "bla"),
    .init(kanjivgId: "030b7", kanaString: "シ", explanation: "bla"),
    .init(kanjivgId: "030b9", kanaString: "ス", explanation: "bla"),
    .init(kanjivgId: "030bb", kanaString: "セ", explanation: "bla"),
    .init(kanjivgId: "030bd", kanaString: "ソ", explanation: "bla"),
    .init(kanjivgId: "030bf", kanaString: "タ", explanation: "bla"),
    .init(kanjivgId: "030c1", kanaString: "チ", explanation: "bla"),
    .init(kanjivgId: "030c4", kanaString: "ツ", explanation: "bla"),
    .init(kanjivgId: "030c6", kanaString: "テ", explanation: "bla"),
    .init(kanjivgId: "030c8", kanaString: "ト", explanation: "bla"),
    .init(kanjivgId: "030ca", kanaString: "ナ", explanation: "bla"),
    .init(kanjivgId: "030cb", kanaString: "ニ", explanation: "bla"),
    .init(kanjivgId: "030cc", kanaString: "ヌ", explanation: "bla"),
    .init(kanjivgId: "030cd", kanaString: "ネ", explanation: "bla"),
    .init(kanjivgId: "030ce", kanaString: "ノ", explanation: "bla"),
    .init(kanjivgId: "030cf", kanaString: "ハ", explanation: "bla"),
    .init(kanjivgId: "030d2", kanaString: "ヒ", explanation: "bla"),
    .init(kanjivgId: "030d5", kanaString: "フ", explanation: "bla"),
    .init(kanjivgId: "030d8", kanaString: "ヘ", explanation: "bla"),
    .init(kanjivgId: "030db", kanaString: "ホ", explanation: "bla"),
    .init(kanjivgId: "030de", kanaString: "マ", explanation: "bla"),
    .init(kanjivgId: "030df", kanaString: "ミ", explanation: "bla"),
    .init(kanjivgId: "030e0", kanaString: "ム", explanation: "bla"),
    .init(kanjivgId: "030e1", kanaString: "メ", explanation: "bla"),
    .init(kanjivgId: "030e2", kanaString: "モ", explanation: "bla"),
    .init(kanjivgId: "030e4", kanaString: "ヤ", explanation: "bla"),
    .init(kanjivgId: "030e6", kanaString: "ユ", explanation: "bla"),
    .init(kanjivgId: "030e8", kanaString: "ヨ", explanation: "bla"),
    .init(kanjivgId: "030e9", kanaString: "ラ", explanation: "bla"),
    .init(kanjivgId: "030ea", kanaString: "リ", explanation: "bla"),
    .init(kanjivgId: "030eb", kanaString: "ル", explanation: "bla"),
    .init(kanjivgId: "030ec", kanaString: "レ", explanation: "bla"),
    .init(kanjivgId: "030ed", kanaString: "ロ", explanation: "bla"),
    .init(kanjivgId: "030ef", kanaString: "ワ", explanation: "bla"),
    .init(kanjivgId: "030f2", kanaString: "ヲ", explanation: "bla"),
    .init(kanjivgId: "030f3", kanaString: "ン", explanation: "bla"),
]
