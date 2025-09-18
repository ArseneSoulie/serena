import Foundation

struct ReinaWord: Identifiable {
    let id: String
    var writings: [String]
    var readings: [String]
}

class ReinaWordXMLParsing: NSObject, XMLParserDelegate {
    init(completion: @escaping (Result<[ReinaWord], Error>) -> Void) {
        self.completion = completion
    }

    private let completion: (Result<[ReinaWord], Error>) -> Void

    private var words: [ReinaWord] = []
    private var currentWord: ReinaWord?
    private var currentElementValue: String = ""

    func parser(
        _: XMLParser,
        didStartElement elementName: String,
        namespaceURI _: String?,
        qualifiedName _: String?,
        attributes attributeDict: [String: String],
    ) {
        if elementName == "entry" {
            if let id = attributeDict["ent_seq"] {
                currentWord = ReinaWord(id: id, writings: [], readings: [])
            }
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
        guard let value = currentElementValue.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
            return
        }

        // Update the current book based on the element we just closed
        switch elementName {
        case "keb":
            currentWord.writings.append(value)
        case "reb":
            currentWord?.readings.append(value)
        case "book":
            if let currentWord {
                words.append(currentWord)
            }
            currentWord = nil
        default:
            break
        }
        currentElementValue = ""
    }

    func parserDidEndDocument(_: XMLParser) {
        print("Parsing finished successfully.")
        completion(.success(words))
    }

    func parser(_: XMLParser, parseErrorOccurred parseError: Error) {
        print("Parsing finished with an error.")
        completion(.failure(parseError))
    }
}
