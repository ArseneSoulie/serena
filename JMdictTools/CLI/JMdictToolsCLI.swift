import ArgumentParser
import Foundation
import ReinaDB

private nonisolated(unsafe) var isAlreadyPrepared: Bool = false

@main
struct JMdictToolsCLI: ParsableCommand {
    init() {
        prepareDB()
    }

    func prepareDB() {
        if !isAlreadyPrepared {
            let databaseURL = URL(fileURLWithPath: "reina.sqlite")
            prepareReinaDB(at: databaseURL)
            reinaLogger.info("CLI using database at: \(databaseURL.path)")
            isAlreadyPrepared = true
        }
    }

    static let configuration = CommandConfiguration(
        commandName: "jmdict-tools",
        abstract: "General purpose tools for working with the JMdict dictionary",
        subcommands: [
            JMdictParserCommand.self,
        ],
        defaultSubcommand: JMdictParserCommand.self,
    )
}
