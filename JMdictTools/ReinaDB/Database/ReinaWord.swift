import SQLiteData

@Table
public struct ReinaWord: Encodable, Sendable, Equatable {
    public let id: String
    public let writing: String?
    public let reading: String
    public let easinessScore: Int

    public init(id: String, writing: String?, reading: String, easinessScore: Int) {
        self.id = id
        self.writing = writing
        self.reading = reading
        self.easinessScore = easinessScore
    }
}
