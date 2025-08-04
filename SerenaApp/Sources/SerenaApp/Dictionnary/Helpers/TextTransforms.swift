import Foundation

extension String {
    var asKatakana: String {
        self.applyingTransform(.hiraganaToKatakana, reverse: false) ?? self
    }
    
    var asHiragana: String {
        self.applyingTransform(.hiraganaToKatakana, reverse: true) ?? self
    }
    
    var asLatin: String {
        self.applyingTransform(.latinToKatakana, reverse: true) ?? self
    }
    
    var latinToKatakana: String {
        self.applyingTransform(.latinToKatakana, reverse: false) ?? self
    }
    
    var latinToHiragana: String {
        latinToKatakana.asHiragana
    }
}

extension String {
    var romajiToKatakana: String {
        romajiToKatakana2(self)
    }
}

let romajiToKatakanaMap: [String: String] = [
    // Vowels
    "a": "ア", "i": "イ", "u": "ウ", "e": "エ", "o": "オ",

    // K
    "ka": "カ", "ki": "キ", "ku": "ク", "ke": "ケ", "ko": "コ",
    "kya": "キャ", "kyu": "キュ", "kyo": "キョ",

    // S
    "sa": "サ", "shi": "シ", "si": "シ", "su": "ス", "se": "セ", "so": "ソ",
    "sha": "シャ", "shu": "シュ", "she": "シェ", "sho": "ショ",
    "sya": "シャ", "syu": "シュ", "syo": "ショ",

    // T
    "ta": "タ", "chi": "チ", "ti": "チ", "tsu": "ツ", "tu": "ツ", "te": "テ", "to": "ト",
    "cha": "チャ", "chu": "チュ", "cho": "チョ", "che": "チェ",
    "tya": "チャ", "tyu": "チュ", "tyo": "チョ",
    "thi": "ティ", "thu": "トゥ",
    "tsa": "ツァ", "tsi": "ツィ", "tse": "ツェ", "tso": "ツォ",
    "tza": "ツァ", "tzi": "ツィ", "tze": "ツェ", "tzo": "ツォ",

    // N
    "na": "ナ", "ni": "ニ", "nu": "ヌ", "ne": "ネ", "no": "ノ",
    "nya": "ニャ", "nyu": "ニュ", "nyo": "ニョ",

    // H
    "ha": "ハ", "hi": "ヒ", "fu": "フ", "hu": "フ", "he": "ヘ", "ho": "ホ",
    "hya": "ヒャ", "hyu": "ヒュ", "hyo": "ヒョ",
    "fyu": "フュ", "fa": "ファ", "fi": "フィ", "fe": "フェ", "fo": "フォ",

    // M
    "ma": "マ", "mi": "ミ", "mu": "ム", "me": "メ", "mo": "モ",
    "mya": "ミャ", "myu": "ミュ", "myo": "ミョ",

    // Y
    "ya": "ヤ", "yu": "ユ", "yo": "ヨ",

    // R
    "ra": "ラ", "ri": "リ", "ru": "ル", "re": "レ", "ro": "ロ",
    "rya": "リャ", "ryu": "リュ", "ryo": "リョ",

    // W
    "wa": "ワ", "wo": "ヲ", "we": "ウェ", "wi": "ウィ", "uxo":"ウォ",

    // N
    "n": "ン", "n'": "ン",

    // G
    "ga": "ガ", "gi": "ギ", "gu": "グ", "ge": "ゲ", "go": "ゴ",
    "gya": "ギャ", "gyu": "ギュ", "gyo": "ギョ",

    // Z/J
    "za": "ザ", "ji": "ジ", "zi": "ジ", "zu": "ズ", "ze": "ゼ", "zo": "ゾ",
    "ja": "ジャ", "ju": "ジュ", "jo": "ジョ", "je": "ジェ",
    "jya": "ジャ", "jyu": "ジュ", "jyo": "ジョ",

    // D
    "da": "ダ", "di": "ヂ", "du": "ヅ", "de": "デ", "do": "ド",
    "dhi": "ディ", "dhu": "ドゥ",
    "dya": "ヂャ", "dyu": "ヂュ", "dyo": "ヂョ",

    // B
    "ba": "バ", "bi": "ビ", "bu": "ブ", "be": "ベ", "bo": "ボ",
    "bya": "ビャ", "byu": "ビュ", "byo": "ビョ",

    // P
    "pa": "パ", "pi": "ピ", "pu": "プ", "pe": "ペ", "po": "ポ",
    "pya": "ピャ", "pyu": "ピュ", "pyo": "ピョ",

    // V
    "va": "ヴァ", "vi": "ヴィ", "vu": "ヴ", "ve": "ヴェ", "vo": "ヴォ", "vyu": "ヴュ",
    "bwa": "ヴァ", "bwi": "ヴィ", "bwe": "ヴェ", "bwo": "ヴォ",

    // D/W combos
    "twa": "トァ", "twi": "トィ", "twu": "トゥ", "twe": "トェ", "two": "トゥ",
    "dwa": "ドァ", "dwi": "ドィ", "dwu": "ドゥ", "dwe": "ドェ", "dwo": "ドォ",
]

func romajiToKatakana2(_ input: String) -> String {
    let lower = input.lowercased()
    var output = ""
    var index = lower.startIndex

    while index < lower.endIndex {
        var matched = false
        for len in (1...3).reversed() {
            guard let end = lower.index(index, offsetBy: len, limitedBy: lower.endIndex) else { continue }
            let slice = String(lower[index..<end])
            if let kana = romajiToKatakanaMap[slice] {
                output += kana
                index = end
                matched = true
                break
            }
        }

        if !matched {
            output += String(lower[index]) // optionally skip or replace
            index = lower.index(after: index)
        }
    }

    return output
}
