import Foundation
import GRDB
import JMdictToolsCore

extension ReinaWord: TableRecord, PersistableRecord {
    public static let databaseTableName = "reinaWords"

    enum Columns: String, ColumnExpression, CodingKey {
        case id
        case writings
        case readings
        case easinessScore
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Columns.self)
        let id = try container.decode(String.self, forKey: .id)

        let writingsData = try container.decode(Data.self, forKey: .writings)
        let writings = try JSONDecoder().decode([String].self, from: writingsData)

        let readingsData = try container.decode(Data.self, forKey: .readings)
        let readings = try JSONDecoder().decode([String].self, from: readingsData)

        let easinessScore = try container.decode(Int.self, forKey: .easinessScore)

        self.init(id: id, writings: writings, readings: readings, easinessScore: easinessScore)
    }

    public func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = id

        if let writingsData = try? JSONEncoder().encode(writings) {
            container[Columns.writings] = writingsData
        }
        if let readingsData = try? JSONEncoder().encode(readings) {
            container[Columns.readings] = readingsData
        }
        if let easinessData = try? JSONEncoder().encode(easinessScore) {
            container[Columns.easinessScore] = easinessData
        }
    }
}
