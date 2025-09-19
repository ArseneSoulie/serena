import ArgumentParser
import Foundation
import JMdictToolsCore

struct JMdictParserCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "parse",
        abstract: "Parse a JMdict XML file and output Reina words.",
    )

    @Argument(help: "The path to the XML file to parse.")
    var xmlFilePath: String

    @Option(
        name: .shortAndLong,
        help: "The output format. Options are: \(OutputFormat.allCases.map(\.rawValue).joined(separator: ", ")).",
    )
    var output: OutputFormat = .json

    func run() throws {
        try parseReinaWords(from: xmlFilePath, onSuccess: reinaCompletion(words:))
    }

    func reinaCompletion(words: [ReinaWord]) {
        switch output {
        case .json: jsonOutput(words: words)
        case .sqlite: sqliteOutput(words: words)
        }
    }

    func jsonOutput(words: [ReinaWord]) {
        do {
            let encoder = JSONEncoder()
            let encodedWords = try encoder.encode(words)
            let jsonWords = String(decoding: encodedWords, as: UTF8.self)
            print(jsonWords)
        } catch {
            print("JSON encoding failed")
        }
    }

    func sqliteOutput(words: [ReinaWord]) {
        do {
            let dbPath = "reina_words.sqlite"
            try seedDatabase(dbPath: dbPath, from: words)
            print("SQLite database successfully seeded \(words.count) words into \(dbPath)")
        } catch {
            print("SQLite encoding failed")
        }
    }

    enum OutputFormat: String, ExpressibleByArgument, CaseIterable {
        case json
        case sqlite
    }
}
