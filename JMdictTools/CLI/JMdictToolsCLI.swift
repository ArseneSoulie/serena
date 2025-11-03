import ArgumentParser
import Foundation

@main
struct JMdictToolsCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "jmdict-tools",
        abstract: "General purpose tools for working with the JMdict dictionary",
        subcommands: [
            JMdictParserCommand.self,
        ],
        defaultSubcommand: JMdictParserCommand.self,
    )
}
