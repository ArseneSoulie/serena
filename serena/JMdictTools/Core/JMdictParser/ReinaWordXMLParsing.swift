import Foundation

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
            currentWord.writings.append(currentElementValue)
        case "reb":
            currentWord.readings.append(currentElementValue)
        case "entry":
            if let id = currentWord.id {
                words.append(ReinaWord(id: id, writings: currentWord.writings, readings: currentWord.readings))
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
}
