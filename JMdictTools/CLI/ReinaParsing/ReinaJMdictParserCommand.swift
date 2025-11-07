import ArgumentParser
import Foundation
import ReinaDB
import SQLiteData

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
        @Dependency(\.defaultDatabase) var database

        let maximumSqliteTransactionSize = 32766
        let wordChunks = words.chunked(into: maximumSqliteTransactionSize)

        withErrorReporting {
            try database.write { db in
                for (index, chunk) in wordChunks.enumerated() {
                    try ReinaWord.upsert {
                        Array(chunk)
                    }.execute(db)

                    print("... Processed chunk \(index + 1)/\(wordChunks.count) (\(chunk.count) words)")
                }
            }
            print("SQLite database successfully seeded \(words.count) words into reina.sqlite at \(database.path)")
            print("Don't forget to copy it to Typist/DB to apply the changes to the app")
        }
    }

    enum OutputFormat: String, ExpressibleByArgument, CaseIterable {
        case json
        case sqlite
    }
}

extension Array {
    func chunked(into size: Int) -> [ArraySlice<Element>] {
        stride(from: 0, to: count, by: size).map {
            self[$0 ..< Swift.min($0 + size, self.count)]
        }
    }
}
