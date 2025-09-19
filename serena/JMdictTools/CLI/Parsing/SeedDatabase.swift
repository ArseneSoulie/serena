import GRDB
import JMdictToolsCore

enum SQLiteError: Error {
    case initializationFailed(path: String, underlyingError: Error)
    case transactionFailed(Error)
}

func seedDatabase(dbPath: String, from words: [ReinaWord]) throws {
    let dbQueue: DatabaseQueue
    do {
        dbQueue = try DatabaseQueue(path: dbPath)
    } catch {
        throw SQLiteError.initializationFailed(path: dbPath, underlyingError: error)
    }

    try dbQueue.write { db in
        try db.create(table: ReinaWord.databaseTableName, ifNotExists: true) { t in
            t.column(ReinaWord.Columns.id.rawValue, .text).primaryKey()
            t.column(ReinaWord.Columns.writings.rawValue, .blob)
            t.column(ReinaWord.Columns.readings.rawValue, .blob)
        }
    }

    try dbQueue.write { db in
        for word in words {
            try word.save(db)
        }
    }
}
