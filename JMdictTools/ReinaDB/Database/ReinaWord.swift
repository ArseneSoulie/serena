import SQLiteData

@Table
public struct ReinaWord: Encodable, Sendable {
    public let id: String
    public let writings: String
    public let readings: String
    public let easinessScore: Int

    public init(id: String, writings: String, readings: String, easinessScore: Int) {
        self.id = id
        self.writings = writings
        self.readings = readings
        self.easinessScore = easinessScore
    }
}
