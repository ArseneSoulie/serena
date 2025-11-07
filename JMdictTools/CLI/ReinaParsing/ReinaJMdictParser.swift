import Foundation
import ReinaDB

// MARK: - Parse Reina words

public func parseReinaWords(from path: String, onSuccess: @escaping ([ReinaWord]) -> Void) throws {
    let data = try validatedData(from: path)

    let parser = XMLParser(data: data)
    let delegate = ReinaWordXMLParsing(onSuccess: onSuccess)
    parser.delegate = delegate

    parser.parse()
}

// MARK: - Errors and Validation

func validatedData(from path: String) throws -> Data {
    let fileURL = URL(fileURLWithPath: path)

    guard FileManager.default.fileExists(atPath: fileURL.path) else {
        print(
            """
            File not found at path: \(path),
            if you're running from xcode try to run the command manually to pass arguments
            """,
        )
        throw ParsingError.validationError
    }

    guard path.hasSuffix(".xml") else {
        print("File is not an XML file.")
        throw ParsingError.validationError
    }

    return try Data(contentsOf: fileURL)
}

enum ParsingError: Error {
    case invalidData
    case parsingFailed(underlyingError: Error)
    case validationError
}
