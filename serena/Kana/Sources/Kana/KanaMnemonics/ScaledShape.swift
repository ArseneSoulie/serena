import SwiftUI

public struct ScaledShape {
    let path: Path
}

extension ScaledShape: Shape {
    public func path(in rect: CGRect) -> Path {
        let boundingRect = path.boundingRect
        let scale = min(rect.width / boundingRect.width, rect.height / boundingRect.height)
        let scaled = path.applying(.init(scaleX: scale, y: scale))
        let scaledBoundingRect = scaled.boundingRect
        let offsetX = scaledBoundingRect.midX - rect.midX
        let offsetY = scaledBoundingRect.midY - rect.midY
        return scaled.offsetBy(dx: -offsetX, dy: -offsetY)
    }
}

public struct ScaledShapeInBounds {
    let path: Path
    let bounds: CGRect
}

extension ScaledShapeInBounds: Shape {
    public func path(in rect: CGRect) -> Path {
        let scale = min(rect.width / bounds.width, rect.height / bounds.height)
        let scaled = path.applying(.init(scaleX: scale, y: scale))
        let scaledBoundingRect = scaled.boundingRect
        let offsetX = scaledBoundingRect.midX - rect.midX
        let offsetY = scaledBoundingRect.midY - rect.midY
        return scaled.offsetBy(dx: -offsetX, dy: -offsetY)
    }
}
