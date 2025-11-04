public struct ReinaWord: Identifiable, Codable {
    public var id: String
    public var writings: [String]
    public var readings: [String]
    public var easinessScore: Int

    public init(id: String, writings: [String], readings: [String], easinessScore: Int) {
        self.id = id
        self.writings = writings
        self.readings = readings
        self.easinessScore = easinessScore
    }
}

struct ReinaWordDraft: Identifiable {
    var id: String?
    var writings: [String] = []
    var readings: [String] = []
    var easinessScore: Int = 1
}
