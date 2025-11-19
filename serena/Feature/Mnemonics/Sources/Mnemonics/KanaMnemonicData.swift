import Foundation
import FoundationModels
import SwiftUI

struct KanaMnemonicData: Identifiable, Hashable {
    let unicodeID: String
    let kanaString: String

    var id: String { kanaString }
}

extension KanaMnemonicData {
    var localisedKey: LocalizedStringResource? {
        switch kanaString {
        case "あ": .mnemonicsあ
        case "い": .mnemonicsい
        case "う": .mnemonicsう
        case "え": .mnemonicsえ
        case "お": .mnemonicsお
        case "か": .mnemonicsか
        case "き": .mnemonicsき
        case "く": .mnemonicsく
        case "け": .mnemonicsけ
        case "こ": .mnemonicsこ
        case "さ": .mnemonicsさ
        case "し": .mnemonicsし
        case "す": .mnemonicsす
        case "せ": .mnemonicsせ
        case "そ": .mnemonicsそ
        case "た": .mnemonicsた
        case "ち": .mnemonicsち
        case "つ": .mnemonicsつ
        case "て": .mnemonicsて
        case "と": .mnemonicsと
        case "な": .mnemonicsな
        case "に": .mnemonicsに
        case "ぬ": .mnemonicsぬ
        case "ね": .mnemonicsね
        case "の": .mnemonicsの
        case "は": .mnemonicsは
        case "ひ": .mnemonicsひ
        case "ふ": .mnemonicsふ
        case "へ": .mnemonicsへ
        case "ほ": .mnemonicsほ
        case "ま": .mnemonicsま
        case "み": .mnemonicsみ
        case "む": .mnemonicsむ
        case "め": .mnemonicsめ
        case "も": .mnemonicsも
        case "や": .mnemonicsや
        case "ゆ": .mnemonicsゆ
        case "よ": .mnemonicsよ
        case "ら": .mnemonicsら
        case "り": .mnemonicsり
        case "る": .mnemonicsる
        case "れ": .mnemonicsれ
        case "ろ": .mnemonicsろ
        case "わ": .mnemonicsわ
        case "を": .mnemonicsを
        case "ん": .mnemonicsん
        case "ア": .mnemonicsア
        case "イ": .mnemonicsイ
        case "ウ": .mnemonicsウ
        case "エ": .mnemonicsエ
        case "オ": .mnemonicsオ
        case "カ": .mnemonicsカ
        case "キ": .mnemonicsキ
        case "ク": .mnemonicsク
        case "ケ": .mnemonicsケ
        case "コ": .mnemonicsコ
        case "サ": .mnemonicsサ
        case "シ": .mnemonicsシ
        case "ス": .mnemonicsス
        case "セ": .mnemonicsセ
        case "ソ": .mnemonicsソ
        case "タ": .mnemonicsタ
        case "チ": .mnemonicsチ
        case "ツ": .mnemonicsツ
        case "テ": .mnemonicsテ
        case "ト": .mnemonicsト
        case "ナ": .mnemonicsナ
        case "ニ": .mnemonicsニ
        case "ヌ": .mnemonicsヌ
        case "ネ": .mnemonicsネ
        case "ノ": .mnemonicsノ
        case "ハ": .mnemonicsハ
        case "ヒ": .mnemonicsヒ
        case "フ": .mnemonicsフ
        case "ヘ": .mnemonicsヘ
        case "ホ": .mnemonicsホ
        case "マ": .mnemonicsマ
        case "ミ": .mnemonicsミ
        case "ム": .mnemonicsム
        case "メ": .mnemonicsメ
        case "モ": .mnemonicsモ
        case "ヤ": .mnemonicsヤ
        case "ユ": .mnemonicsユ
        case "ヨ": .mnemonicsヨ
        case "ラ": .mnemonicsラ
        case "リ": .mnemonicsリ
        case "ル": .mnemonicsル
        case "レ": .mnemonicsレ
        case "ロ": .mnemonicsロ
        case "ワ": .mnemonicsワ
        case "ヲ": .mnemonicsヲ
        case "ン": .mnemonicsン
        default: nil
        }
    }
}

extension KanaType {
    var mnemonicGroups: [MnemonicGroup] {
        switch self {
        case .hiragana: hiraganaMnemonicsData
        case .katakana: katakanaMnemonicsData
        }
    }
}

struct MnemonicGroup {
    let title: String?
    let color: Color
    let data: [KanaMnemonicData]
}

let hiraganaMnemonicsData: [MnemonicGroup] = [
    .init(
        title: nil,
        color: .purple,
        data: [
            .init(unicodeID: "3042", kanaString: "あ"),
            .init(unicodeID: "3044", kanaString: "い"),
            .init(unicodeID: "3046", kanaString: "う"),
            .init(unicodeID: "3048", kanaString: "え"),
            .init(unicodeID: "304a", kanaString: "お"),
        ],
    ),
    .init(
        title: "k-",
        color: .red,
        data: [
            .init(unicodeID: "304b", kanaString: "か"),
            .init(unicodeID: "304d", kanaString: "き"),
            .init(unicodeID: "304f", kanaString: "く"),
            .init(unicodeID: "3051", kanaString: "け"),
            .init(unicodeID: "3053", kanaString: "こ"),
        ],
    ),
    .init(
        title: "s-",
        color: .orange,
        data: [
            .init(unicodeID: "3055", kanaString: "さ"),
            .init(unicodeID: "3057", kanaString: "し"),
            .init(unicodeID: "3059", kanaString: "す"),
            .init(unicodeID: "305b", kanaString: "せ"),
            .init(unicodeID: "305d", kanaString: "そ"),
        ],
    ),
    .init(
        title: "t-",
        color: .yellow,
        data: [
            .init(unicodeID: "305f", kanaString: "た"),
            .init(unicodeID: "3061", kanaString: "ち"),
            .init(unicodeID: "3064", kanaString: "つ"),
            .init(unicodeID: "3066", kanaString: "て"),
            .init(unicodeID: "3068", kanaString: "と"),
        ],
    ),
    .init(
        title: "n-",
        color: .green,
        data: [
            .init(unicodeID: "306a", kanaString: "な"),
            .init(unicodeID: "306b", kanaString: "に"),
            .init(unicodeID: "306c", kanaString: "ぬ"),
            .init(unicodeID: "306d", kanaString: "ね"),
            .init(unicodeID: "306e", kanaString: "の"),
        ],
    ),
    .init(
        title: "h-",
        color: .blue,
        data: [
            .init(unicodeID: "306f", kanaString: "は"),
            .init(unicodeID: "3072", kanaString: "ひ"),
            .init(unicodeID: "3075", kanaString: "ふ"),
            .init(unicodeID: "3078", kanaString: "へ"),
            .init(unicodeID: "307b", kanaString: "ほ"),
        ],
    ),
    .init(
        title: "m-",
        color: .cyan,
        data: [
            .init(unicodeID: "307e", kanaString: "ま"),
            .init(unicodeID: "307f", kanaString: "み"),
            .init(unicodeID: "3080", kanaString: "む"),
            .init(unicodeID: "3081", kanaString: "め"),
            .init(unicodeID: "3082", kanaString: "も"),
        ],
    ),
    .init(
        title: "y-",
        color: .pink,
        data: [
            .init(unicodeID: "3084", kanaString: "や"),
            .init(unicodeID: "3086", kanaString: "ゆ"),
            .init(unicodeID: "3088", kanaString: "よ"),
        ],
    ),
    .init(
        title: "r-",
        color: .brown,
        data: [
            .init(unicodeID: "3089", kanaString: "ら"),
            .init(unicodeID: "308a", kanaString: "り"),
            .init(unicodeID: "308b", kanaString: "る"),
            .init(unicodeID: "308c", kanaString: "れ"),
            .init(unicodeID: "308d", kanaString: "ろ"),
        ],
    ),
    .init(
        title: "w-",
        color: .indigo,
        data: [
            .init(unicodeID: "308f", kanaString: "わ"),
            .init(unicodeID: "3092", kanaString: "を"),
        ],
    ),
    .init(
        title: "n",
        color: .mint,
        data: [
            .init(unicodeID: "3093", kanaString: "ん"),
        ],
    ),
]

let katakanaMnemonicsData: [MnemonicGroup] = [
    .init(
        title: nil,
        color: .purple,
        data: [
            .init(unicodeID: "30a2", kanaString: "ア"),
            .init(unicodeID: "30a4", kanaString: "イ"),
            .init(unicodeID: "30a6", kanaString: "ウ"),
            .init(unicodeID: "30a8", kanaString: "エ"),
            .init(unicodeID: "30aa", kanaString: "オ"),
        ],
    ),
    .init(
        title: "K-",
        color: .red,
        data: [
            .init(unicodeID: "30ab", kanaString: "カ"),
            .init(unicodeID: "30ad", kanaString: "キ"),
            .init(unicodeID: "30af", kanaString: "ク"),
            .init(unicodeID: "30b1", kanaString: "ケ"),
            .init(unicodeID: "30b3", kanaString: "コ"),
        ],
    ),
    .init(
        title: "S-",
        color: .orange,
        data: [
            .init(unicodeID: "30b5", kanaString: "サ"),
            .init(unicodeID: "30b7", kanaString: "シ"),
            .init(unicodeID: "30b9", kanaString: "ス"),
            .init(unicodeID: "30bb", kanaString: "セ"),
            .init(unicodeID: "30bd", kanaString: "ソ"),
        ],
    ),
    .init(
        title: "T-",
        color: .yellow,
        data: [
            .init(unicodeID: "30bf", kanaString: "タ"),
            .init(unicodeID: "30c1", kanaString: "チ"),
            .init(unicodeID: "30c4", kanaString: "ツ"),
            .init(unicodeID: "30c6", kanaString: "テ"),
            .init(unicodeID: "30c8", kanaString: "ト"),
        ],
    ),
    .init(
        title: "N-",
        color: .green,
        data: [
            .init(unicodeID: "30ca", kanaString: "ナ"),
            .init(unicodeID: "30cb", kanaString: "ニ"),
            .init(unicodeID: "30cc", kanaString: "ヌ"),
            .init(unicodeID: "30cd", kanaString: "ネ"),
            .init(unicodeID: "30ce", kanaString: "ノ"),
        ],
    ),
    .init(
        title: "H-",
        color: .blue,
        data: [
            .init(unicodeID: "30cf", kanaString: "ハ"),
            .init(unicodeID: "30d2", kanaString: "ヒ"),
            .init(unicodeID: "30d5", kanaString: "フ"),
            .init(unicodeID: "30d8", kanaString: "ヘ"),
            .init(unicodeID: "30db", kanaString: "ホ"),
        ],
    ),
    .init(
        title: "M-",
        color: .cyan,
        data: [
            .init(unicodeID: "30de", kanaString: "マ"),
            .init(unicodeID: "30df", kanaString: "ミ"),
            .init(unicodeID: "30e0", kanaString: "ム"),
            .init(unicodeID: "30e1", kanaString: "メ"),
            .init(unicodeID: "30e2", kanaString: "モ"),
        ],
    ),
    .init(
        title: "Y-",
        color: .pink,
        data: [
            .init(unicodeID: "30e4", kanaString: "ヤ"),
            .init(unicodeID: "30e6", kanaString: "ユ"),
            .init(unicodeID: "30e8", kanaString: "ヨ"),
        ],
    ),
    .init(
        title: "R-",
        color: .brown,
        data: [
            .init(unicodeID: "30e9", kanaString: "ラ"),
            .init(unicodeID: "30ea", kanaString: "リ"),
            .init(unicodeID: "30eb", kanaString: "ル"),
            .init(unicodeID: "30ec", kanaString: "レ"),
            .init(unicodeID: "30ed", kanaString: "ロ"),
        ],
    ),
    .init(
        title: "W-",
        color: .indigo,
        data: [
            .init(unicodeID: "30ef", kanaString: "ワ"),
            .init(unicodeID: "30f2", kanaString: "ヲ"),
        ],
    ),
    .init(
        title: "N",
        color: .mint,
        data: [
            .init(unicodeID: "30f3", kanaString: "ン"),
        ],
    ),
]
