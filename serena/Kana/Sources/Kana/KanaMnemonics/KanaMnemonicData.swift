import Foundation
import FoundationModels

struct KanaMnemonicData: Identifiable, Hashable {
    let id: UUID = .init()
    let unicodeID: String
    let kanaString: String
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
    .init(unicodeID: "3042", kanaString: "あ"),
    .init(unicodeID: "3044", kanaString: "い"),
    .init(unicodeID: "3046", kanaString: "う"),
    .init(unicodeID: "3048", kanaString: "え"),
    .init(unicodeID: "304a", kanaString: "お"),
    .init(unicodeID: "304b", kanaString: "か"),
    .init(unicodeID: "304d", kanaString: "き"),
    .init(unicodeID: "304f", kanaString: "く"),
    .init(unicodeID: "3051", kanaString: "け"),
    .init(unicodeID: "3053", kanaString: "こ"),
    .init(unicodeID: "3055", kanaString: "さ"),
    .init(unicodeID: "3057", kanaString: "し"),
    .init(unicodeID: "3059", kanaString: "す"),
    .init(unicodeID: "305b", kanaString: "せ"),
    .init(unicodeID: "305d", kanaString: "そ"),
    .init(unicodeID: "305f", kanaString: "た"),
    .init(unicodeID: "3061", kanaString: "ち"),
    .init(unicodeID: "3064", kanaString: "つ"),
    .init(unicodeID: "3066", kanaString: "て"),
    .init(unicodeID: "3068", kanaString: "と"),
    .init(unicodeID: "306a", kanaString: "な"),
    .init(unicodeID: "306b", kanaString: "に"),
    .init(unicodeID: "306c", kanaString: "ぬ"),
    .init(unicodeID: "306d", kanaString: "ね"),
    .init(unicodeID: "306e", kanaString: "の"),
    .init(unicodeID: "306f", kanaString: "は"),
    .init(unicodeID: "3072", kanaString: "ひ"),
    .init(unicodeID: "3075", kanaString: "ふ"),
    .init(unicodeID: "3078", kanaString: "へ"),
    .init(unicodeID: "307b", kanaString: "ほ"),
    .init(unicodeID: "307e", kanaString: "ま"),
    .init(unicodeID: "307f", kanaString: "み"),
    .init(unicodeID: "3080", kanaString: "む"),
    .init(unicodeID: "3081", kanaString: "め"),
    .init(unicodeID: "3082", kanaString: "も"),
    .init(unicodeID: "3084", kanaString: "や"),
    .init(unicodeID: "3086", kanaString: "ゆ"),
    .init(unicodeID: "3088", kanaString: "よ"),
    .init(unicodeID: "3089", kanaString: "ら"),
    .init(unicodeID: "308a", kanaString: "り"),
    .init(unicodeID: "308b", kanaString: "る"),
    .init(unicodeID: "308c", kanaString: "れ"),
    .init(unicodeID: "308d", kanaString: "ろ"),
    .init(unicodeID: "308f", kanaString: "わ"),
    .init(unicodeID: "3092", kanaString: "を"),
    .init(unicodeID: "3093", kanaString: "ん"),
]

let katakanaMnemonicsData: [KanaMnemonicData] = [
    .init(unicodeID: "30a2", kanaString: "ア"),
    .init(unicodeID: "30a4", kanaString: "イ"),
    .init(unicodeID: "30a6", kanaString: "ウ"),
    .init(unicodeID: "30a8", kanaString: "エ"),
    .init(unicodeID: "30aa", kanaString: "オ"),
    .init(unicodeID: "30ab", kanaString: "カ"),
    .init(unicodeID: "30ad", kanaString: "キ"),
    .init(unicodeID: "30af", kanaString: "ク"),
    .init(unicodeID: "30b1", kanaString: "ケ"),
    .init(unicodeID: "30b3", kanaString: "コ"),
    .init(unicodeID: "30b5", kanaString: "サ"),
    .init(unicodeID: "30b7", kanaString: "シ"),
    .init(unicodeID: "30b9", kanaString: "ス"),
    .init(unicodeID: "30bb", kanaString: "セ"),
    .init(unicodeID: "30bd", kanaString: "ソ"),
    .init(unicodeID: "30bf", kanaString: "タ"),
    .init(unicodeID: "30c1", kanaString: "チ"),
    .init(unicodeID: "30c4", kanaString: "ツ"),
    .init(unicodeID: "30c6", kanaString: "テ"),
    .init(unicodeID: "30c8", kanaString: "ト"),
    .init(unicodeID: "30ca", kanaString: "ナ"),
    .init(unicodeID: "30cb", kanaString: "ニ"),
    .init(unicodeID: "30cc", kanaString: "ヌ"),
    .init(unicodeID: "30cd", kanaString: "ネ"),
    .init(unicodeID: "30ce", kanaString: "ノ"),
    .init(unicodeID: "30cf", kanaString: "ハ"),
    .init(unicodeID: "30d2", kanaString: "ヒ"),
    .init(unicodeID: "30d5", kanaString: "フ"),
    .init(unicodeID: "30d8", kanaString: "ヘ"),
    .init(unicodeID: "30db", kanaString: "ホ"),
    .init(unicodeID: "30de", kanaString: "マ"),
    .init(unicodeID: "30df", kanaString: "ミ"),
    .init(unicodeID: "30e0", kanaString: "ム"),
    .init(unicodeID: "30e1", kanaString: "メ"),
    .init(unicodeID: "30e2", kanaString: "モ"),
    .init(unicodeID: "30e4", kanaString: "ヤ"),
    .init(unicodeID: "30e6", kanaString: "ユ"),
    .init(unicodeID: "30e8", kanaString: "ヨ"),
    .init(unicodeID: "30e9", kanaString: "ラ"),
    .init(unicodeID: "30ea", kanaString: "リ"),
    .init(unicodeID: "30eb", kanaString: "ル"),
    .init(unicodeID: "30ec", kanaString: "レ"),
    .init(unicodeID: "30ed", kanaString: "ロ"),
    .init(unicodeID: "30ef", kanaString: "ワ"),
    .init(unicodeID: "30f2", kanaString: "ヲ"),
    .init(unicodeID: "30f3", kanaString: "ン"),
]
