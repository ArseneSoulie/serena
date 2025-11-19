import SwiftUI

public enum BorderStyle {
    /// 1
    case `default`
    /// 2
    case moderate
    /// 3
    case strong

    public var baseValue: CGFloat {
        switch self {
        case .default: 1
        case .moderate: 2
        case .strong: 3
        }
    }
}

public extension UIView {
    @discardableResult
    func applyBorderStyle(_ borderStyle: BorderStyle) -> Self {
        layer.borderWidth = borderStyle.baseValue
        return self
    }
}

public extension View {
    func border(
        style: some ShapeStyle,
        width: BorderStyle = .default,
        cornerRadius: RadiusStyle = .default,
    ) -> some View {
        modifier(
            RoundedBorderModifier(
                style: style,
                width: width.baseValue,
                cornerRadius: cornerRadius.baseValue,
            ),
        )
    }
}

public struct RadiiStyle {
    let topLeading: RadiusStyle
    let topTrailing: RadiusStyle
    let bottomLeading: RadiusStyle
    let bottomTrailing: RadiusStyle
}

public extension View {
    func border(
        style: some ShapeStyle,
        width: BorderStyle = .default,
        cornerRadii: RadiiStyle,
    ) -> some View {
        modifier(
            UnevenRoundedBorderModifier(
                style: style,
                width: width.baseValue,
                cornerRadii: .init(
                    topLeading: cornerRadii.topLeading.baseValue,
                    bottomLeading: cornerRadii.bottomLeading.baseValue,
                    bottomTrailing: cornerRadii.bottomTrailing.baseValue,
                    topTrailing: cornerRadii.topTrailing.baseValue,
                ),
            ),
        )
    }
}

struct RoundedBorderModifier<S>: ViewModifier where S: ShapeStyle {
    let style: S
    let width: CGFloat
    let cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(style: .init(lineWidth: width))
                    .foregroundStyle(style)
            }
    }
}

struct UnevenRoundedBorderModifier<S>: ViewModifier where S: ShapeStyle {
    let style: S
    let width: CGFloat
    let cornerRadii: RectangleCornerRadii
    func body(content: Content) -> some View {
        content
            .overlay {
                UnevenRoundedRectangle(cornerRadii: cornerRadii)
                    .stroke(style: .init(lineWidth: width))
                    .foregroundStyle(style)
            }
    }
}
