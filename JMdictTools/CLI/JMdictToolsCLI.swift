import ArgumentParser
import Foundation
import ReinaDB

@main
struct JMdictToolsCLI: ParsableCommand {
    init() {
        if JMdictToolsCLI.isAlreadyInstantiated {
            return
        }
        let databaseURL = URL(fileURLWithPath: "reina.sqlite")
        prepareReinaDB(at: databaseURL)
        reinaLogger.info("CLI using database at: \(databaseURL.path)")
        JMdictToolsCLI.isAlreadyInstantiated = true
    }

    nonisolated(unsafe) static var isAlreadyInstantiated: Bool = false

    static let configuration = CommandConfiguration(
        commandName: "jmdict-tools",
        abstract: "General purpose tools for working with the JMdict dictionary",
        subcommands: [
            JMdictParserCommand.self,
        ],
        defaultSubcommand: JMdictParserCommand.self,
    )
}
