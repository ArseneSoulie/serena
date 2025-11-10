import Foundation

struct TextToType: Equatable, Identifiable {
    let id = UUID()
    let value: String
    let x: Double
    var y: Double
}
