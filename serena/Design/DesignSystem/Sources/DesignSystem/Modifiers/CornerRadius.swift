import SwiftUI

public enum RadiusStyle {
    /// 16
    case `default`
    /// 20
    case moderate
    /// 24
    case strong
    /// 100%
    case round
}

package extension RadiusStyle {
    var baseValue: CGFloat {
        switch self {
        case .default: 16
        case .moderate: 20
        case .strong: 24
        case .round: .infinity
        }
    }
}

public extension View {
    /// Clip a view to have rounded corners
    package func cornerRadius(_ radiusStyle: RadiusStyle) -> some View {
        modifier(CornerRadiusModifier(radiusStyle: radiusStyle))
    }

    /// Clip a view to have rounded corners on specified corners
    func cornerRadius(_ radiusStyle: RadiusStyle, to corners: UIRectCorner = .allCorners) -> some View {
        modifier(CornerRadiusModifierWithSpecificCorners(radiusStyle: radiusStyle, corners: corners))
    }
}

private struct CornerRadiusModifier: ViewModifier {
    let radiusStyle: RadiusStyle

    func body(content: Content) -> some View {
        content
            .clipShape(.rect(cornerRadius: radiusStyle.baseValue))
    }
}

private struct CornerRadiusModifierWithSpecificCorners: ViewModifier {
    let radiusStyle: RadiusStyle
    let corners: UIRectCorner

    func body(content: Content) -> some View {
        content
            .clipShape(RoundedCorner(radius: radiusStyle.baseValue, corners: corners))
    }
}

public extension View {
    func presentationSheetCornerRadius(_ radiusStyle: RadiusStyle) -> some View {
        modifier(PresentationCornerRadiusModifier(radiusStyle: radiusStyle))
    }
}

private struct PresentationCornerRadiusModifier: ViewModifier {
    let radiusStyle: RadiusStyle
    fileprivate func body(content: Content) -> some View {
        content
            .presentationCornerRadius(radiusStyle.baseValue)
    }
}

private struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius),
        )
        return Path(path.cgPath)
    }
}
