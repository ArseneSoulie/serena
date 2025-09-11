import SwiftUI

public struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var rotation: Angle = .degrees(2)
    public var animatableData: CGFloat

    public func effectValue(size: CGSize) -> ProjectionTransform {
        let shake = amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        let angle = CGFloat(rotation.radians) * sin(animatableData * .pi * CGFloat(shakesPerUnit))

        var transform = CGAffineTransform.identity

        transform = transform.translatedBy(x: size.width / 2, y: size.height / 2)

        transform = transform.rotated(by: angle)
        transform = transform.translatedBy(x: shake, y: 0)

        transform = transform.translatedBy(x: -size.width / 2, y: -size.height / 2)

        return ProjectionTransform(transform)
    }
}

public extension View {
    func shake(
        amount: CGFloat = 10,
        shakesPerUnit: Int = 3,
        rotation: Angle = .degrees(2),
        _ animatableData: CGFloat = 0,
    ) -> some View {
        modifier(ShakeEffect(
            amount: amount,
            shakesPerUnit: shakesPerUnit,
            rotation: rotation,
            animatableData: animatableData,
        ))
    }
}
