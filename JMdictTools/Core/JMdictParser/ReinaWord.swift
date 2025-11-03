public struct ReinaWord: Identifiable, Codable {
    public var id: String
    public var writings: [String]
    public var readings: [String]

    public init(id: String, writings: [String], readings: [String]) {
        self.id = id
        self.writings = writings
        self.readings = readings
    }
}

struct ReinaWordDraft: Identifiable {
    var id: String?
    var writings: [String]
    var readings: [String]

    init(id: String? = nil, writings: [String] = [], readings: [String] = []) {
        self.id = id
        self.writings = writings
        self.readings = readings
    }
}
