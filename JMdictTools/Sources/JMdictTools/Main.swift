import ArgumentParser
import Foundation

@main
struct JMdictTools: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "jmdict-tools",
        abstract: "General purpose tools for working with the JMdict dictionary",
        subcommands: [
            JMdictParser.self,
        ],
        defaultSubcommand: JMdictParser.self,
    )
}
