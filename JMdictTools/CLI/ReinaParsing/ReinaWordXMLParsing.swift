import Foundation
import ReinaDB

struct ReinaWordDraft {
    var id: String?
    var mainWriting: String?
    var mainReading: String?
    var easinessScore: Int = 1
}

class ReinaWordXMLParsing: NSObject, XMLParserDelegate {
    init(onSuccess: @escaping ([ReinaWord]) -> Void) {
        self.onSuccess = onSuccess
    }

    private let onSuccess: ([ReinaWord]) -> Void

    private var words: [ReinaWord] = []
    private var currentWord: ReinaWordDraft = .init()
    private var currentElementValue: String = ""

    func parser(
        _: XMLParser,
        didStartElement elementName: String,
        namespaceURI _: String?,
        qualifiedName _: String?,
        attributes _: [String: String],
    ) {
        if elementName == "entry" {
            currentWord = ReinaWordDraft()
        }
        currentElementValue = ""
    }

    func parser(_: XMLParser, foundCharacters string: String) {
        currentElementValue += string
    }

    func parser(
        _: XMLParser,
        didEndElement elementName: String,
        namespaceURI _: String?,
        qualifiedName _: String?,
    ) {
        switch elementName {
        case "ent_seq":
            currentWord.id = currentElementValue
        case "keb":
            currentWord.mainWriting = currentElementValue
        case "reb":
            currentWord.mainReading = currentElementValue
        case "re_pri", "ke_pri":
            currentWord.easinessScore = max(currentWord.easinessScore, easinessScore(for: currentElementValue))
        case "entry":
            if let id = currentWord.id, let reading = currentWord.mainReading {
                words.append(
                    ReinaWord(
                        id: id,
                        writing: currentWord.mainWriting,
                        reading: reading,
                        easinessScore: currentWord.easinessScore,
                    ),
                )
            }
        default:
            break
        }
        currentElementValue = ""
    }

    func parserDidEndDocument(_: XMLParser) {
        onSuccess(words)
    }

    func parser(_: XMLParser, parseErrorOccurred parseError: Error) {
        print("XML Parsing Error: \(parseError.localizedDescription)")
    }

    /*
     The easiness score is based on the maximum value of the priority code

     Priority Code(s)             Rank/Range (Approx.)           Inferred Easiness Score (1-10)
     nf01                         Top 500                        10
     nf02 - nf10                  501 - 5,000                    9
     nf11 - nf24                  5,001 - 12,000 (news1)         8
     ichi1, spec1, gai1           High Priority Lists            8 (Treated as strong common vocabulary)
     nf25 - nf48                  12,001 - 24,000 (news2)        6
     ichi2, spec2, gai2           Mid Priority Lists             5 (Common but lower frequency)
     Any other nfxx code          > 24,000                       3
     None (No ke_pri / re_pri)    Not ranked in major lists      1 (Rare/Specialized/Infrequent)
     */
    func easinessScore(for priorityCode: String) -> Int {
        if priorityCode.hasPrefix("nf"), let number = Int(priorityCode.dropFirst(2)) {
            if number == 1 {
                return 10
            }
            if (2 ... 10).contains(number) {
                return 9
            }
            if (11 ... 24).contains(number) {
                return 8
            }
            if (25 ... 48).contains(number) {
                return 6
            }
            if number > 48 {
                return 3
            }
        }

        return switch priorityCode {
        case "ichi1", "spec1", "gai1", "news1": 8
        case "ichi2", "spec2", "gai2", "news2": 5
        default: 1
        }
    }
}
