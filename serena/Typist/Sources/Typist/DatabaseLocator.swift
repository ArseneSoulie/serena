import Foundation

public enum DatabaseLocator {
    public static var reinaDatabaseURL: URL {
        guard let url = Bundle.module.url(forResource: "reina", withExtension: "sqlite") else {
            fatalError("""
            Missing 'reina.sqlite' in Typist bundle.
            Don't forget to copy the DB to 'serena/Typist/Sources/Typist/DB' after generating it from the CLI
            """)
        }
        return url
    }
}
