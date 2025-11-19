import Foundation
import ReinaDB

struct TextToType: Equatable, Identifiable {
    let id = UUID()
    let word: ReinaWord
    let x: Double
    var y: Double
}
