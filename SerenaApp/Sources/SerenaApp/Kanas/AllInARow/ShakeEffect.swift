import SwiftUI

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var rotation: Angle = .degrees(2)
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
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
