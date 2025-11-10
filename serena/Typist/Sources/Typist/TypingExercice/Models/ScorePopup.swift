import Foundation

struct ScorePopup: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let x: Double
    let y: Double
    var opacity: Double = 1.0
    var offsetY: CGFloat = 0
}
