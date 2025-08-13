import Foundation

struct KanaLine: Identifiable, Hashable {
    let name: String
    let kanas: [KanaText?]
    
    var id: String { name }
}

typealias KanaText = String

extension KanaText? {
    var kanaId: String {
        if let self {
            self
        } else {
            UUID().uuidString
        }
    }
}

let base: [KanaLine] = [
    .init(name:"-" , kanas:["a","i","u","e","o"]),
    .init(name:"k-" , kanas:["ka","ki","ku","ke","ko"]),
    .init(name:"s-" , kanas:["sa","shi","su","se","so"]),
    .init(name:"t-" , kanas:["ta","chi","tsu","te","to"]),
    .init(name:"n-" , kanas:["na","ni","nu","ne","no"]),
    .init(name:"h-" , kanas:["ha","hi","fu","he","ho"]),
    .init(name:"m-" , kanas:["ma","mi","mu","me","mo"]),
    .init(name:"y-" , kanas:["ya",nil,"yu",nil,"yo"]),
    .init(name:"r-" , kanas:["ra","ri","ru","re","ro"]),
    .init(name:"w-" , kanas:["wa",nil,nil,nil,"wo"]),
    .init(name:"n" , kanas:["n"]),
]

let diacritic: [KanaLine] = [
    .init(name:"g-" , kanas:["ga","gi","gu","ge","go"]),
    .init(name:"z-" , kanas:["za","ji","zu","ze","zo"]),
    .init(name:"d-" , kanas:["da","di","du","de","do"]),
    .init(name:"b-" , kanas:["ba","bi","bu","be","bo"]),
    .init(name:"p-" , kanas:["pa","pi","pu","pe","po"]),
]

let combinatory: [KanaLine] = [
    .init(name:"ky-" , kanas:["kya","kyu","kyo"]),
    .init(name:"sh-" , kanas:["sha","shu","sho"]),
    .init(name:"ch-" , kanas:["cha","chu","cho"]),
    .init(name:"ny-" , kanas:["nya","nyu","nyo"]),
    .init(name:"hy-" , kanas:["hya","hyu","hyo"]),
    .init(name:"my-" , kanas:["mya","myu","myo"]),
    .init(name:"ry-" , kanas:["rya","ryu","ryo"]),
]

let combinatoryDiacritic: [KanaLine] = [
    .init(name:"gy-" , kanas:["gya","gyu","gyo"]),
    .init(name:"j-" , kanas:["ja","ju","jo"]),
    .init(name:"dy-" , kanas:["dya","dyu","dyo"]),
    .init(name:"by-" , kanas:["bya","byu","byo"]),
    .init(name:"py-" , kanas:["pya","pyu","pyo"]),
]

let extendedKatakana: [KanaLine] = [
    .init(name:"sh-" , kanas:["she"]),
    .init(name:"j-" , kanas:["je"]),
    .init(name:"ch-" , kanas:["che"]),
    .init(name:"ts-" , kanas:["tsa","tsi","tse","tso"]),
    .init(name:"f-" , kanas:["fa","fi","fe","fo"]),
    .init(name:"y-" , kanas:["ye"]),
    .init(name:"w-" , kanas:["wi","we","uxo"]),
    .init(name:"v-" , kanas:["va","vi","vu","ve","vo"]),
    .init(name:"∗" , kanas:["thi","dhi","twu","dwu"]),
]
