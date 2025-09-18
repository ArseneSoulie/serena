import ArgumentParser
import Foundation

extension JMdictTools {
    struct JMdictParser: ParsableCommand {
        @Argument(help: "The path to the XML file to parse.")
        var xmlFilePath: String

        func run() throws {
            parseReinaWords()
        }
    }
}

// MARK: - Parse Reina words

extension JMdictTools.JMDictParser {
    func parseReinaWords() throws {
        let onParsingCompleted: (Result<[ReinaWord], Error>) -> Void = { result in
            switch result {
            case let .success(words):
                print(words)
            case let .failure(failure):
                throw ValidationError("Parsing failed: \(failure)")
            }
        }

        let data = try validatedData(from: xmlFilePath)

        let parser = XMLParser(data: data)
        let delegate = ReinaWordXMLParsing(completion: onParsingCompleted)
        parser.delegate = delegate

        parser.parse()
    }
}

// MARK: - Errors and Validation

extension JMdictTools.JMDictParser {
    func validatedData(from path: String) throws -> Data {
        let fileURL = URL(fileURLWithPath: path)

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw ValidationError("File not found at path: \(path)")
        }

        guard path.hasSuffix(".xml") else {
            throw ValidationError("File is not an XML file.")
        }

        return try Data(contentsOf: fileURL)
    }

    enum ParsingError: Error {
        case invalidData
        case parsingFailed(underlyingError: Error)
    }
}
