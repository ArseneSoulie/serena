import Foundation
import OSLog
import SQLiteData

package nonisolated let reinaLogger = Logger(subsystem: "Reina", category: "Database")

// MARK: - Prepare DB

public func prepareReinaDB(at dbURL: URL) {
    prepareDependencies {
        $0.defaultDatabase = try! reinaAppDatabase(at: dbURL)
    }
}

// MARK: - Setup

public func reinaAppDatabase(at dbURL: URL) throws -> any DatabaseWriter {
    @Dependency(\.context) var context
    var configuration = Configuration()
    #if DEBUG
        configuration.prepareDatabase { db in
            db.trace(options: .profile) {
                if context == .preview {
                    print("\($0.expandedDescription)")
                } else {
                    reinaLogger.debug("\($0.expandedDescription)")
                }
            }
        }
    #endif
    let database = try defaultDatabase(path: dbURL.path, configuration: configuration)
    reinaLogger.info("open '\(database.path)'")

    try reinaDatabaseMigrator().migrate(database)

    return database
}

// MARK: - Migration

func reinaDatabaseMigrator() -> DatabaseMigrator {
    var migrator = DatabaseMigrator()
    #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
    #endif
    migrator.registerMigration("Create table") { db in
        try #sql("""
        CREATE TABLE "reinawords" (
            "id" TEXT NOT NULL PRIMARY KEY,
            "writing" TEXT,
            "reading" TEXT NOT NULL,
            "easinessScore" INTEGER NOT NULL
        ) STRICT ;
        """)
        .execute(db)
    }
    return migrator
}
