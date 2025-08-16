import SwiftUI

struct KanjiStrokes {
    let strokes: [Stroke]

    var path: Path {
        var absolutePath = Path()
        for stroke in strokes {
            absolutePath.addPath(stroke.path)
        }
        return absolutePath
    }

    init?(from url: URL) {
        guard let svgData = try? Data(contentsOf: url) else { return nil }
        let strokes = KanjiVGParser().parse(data: svgData)
        guard !strokes.isEmpty else { return nil }
        self.strokes = strokes
    }
}

extension KanjiStrokes: Shape {
    func path(in rect: CGRect) -> Path {
        let boundingRect = path.boundingRect
        let scale = min(rect.width / boundingRect.width, rect.height / boundingRect.height)
        let scaled = path.applying(.init(scaleX: scale, y: scale))
        let scaledBoundingRect = scaled.boundingRect
        let offsetX = scaledBoundingRect.midX - rect.midX
        let offsetY = scaledBoundingRect.midY - rect.midY
        return scaled.offsetBy(dx: -offsetX, dy: -offsetY)
    }
}
