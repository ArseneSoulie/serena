import Foundation
import SwiftUI

public struct Typography: Sendable {
    let size: CGFloat
    let relativeTo: SwiftUI.Font.TextStyle
}

public extension Typography {
    static let largeTitle: Typography = .init(
        size: 56,
        relativeTo: .largeTitle,
    )

    static let title: Typography = .init(
        size: 30,
        relativeTo: .title,
    )

    static let title2: Typography = .init(
        size: 22,
        relativeTo: .title2,
    )

    static let headline: Typography = .init(
        size: 16,
        relativeTo: .headline,
    )

    static let body: Typography = .init(
        size: 16,
        relativeTo: .body,
    )

    static let callout: Typography = .init(
        size: 14,
        relativeTo: .callout,
    )

    static let caption: Typography = .init(
        size: 13,
        relativeTo: .caption,
    )

    static let caption2: Typography = .init(
        size: 12,
        relativeTo: .caption2,
    )

    static let footnote: Typography = .init(
        size: 10,
        relativeTo: .footnote,
    )

    static let defaultFont: SwiftUI.Font = CustomFontFamily.defaultFamily.fontConvertible.swiftUIFont(typography: .body)
}

extension FontConvertible {
    func swiftUIFont(typography: Typography) -> SwiftUI.Font {
        SwiftUI.Font.custom(self, size: typography.size, relativeTo: typography.relativeTo)
    }

    func font(typography: Typography) -> UIFont {
        font(size: typography.size)
    }
}

struct TypographyModifier: ViewModifier {
    let typography: Typography
    let fontFamily: CustomFontFamily

    func body(content: Content) -> some View {
        content
            .font(fontFamily.fontConvertible.swiftUIFont(typography: typography))
    }
}

public enum CustomFontFamily: String, CaseIterable, Sendable {
    case hachiMaruPop
    case yujiBoku
    case yujiMai
    case yujiSyuku
    case mPlus

    var fontConvertible: FontConvertible {
        switch self {
        case .hachiMaruPop: FontFamily.HachiMaruPop.regular
        case .yujiBoku: FontFamily.YujiBoku.regular
        case .yujiMai: FontFamily.YujiMai.regular
        case .yujiSyuku: FontFamily.YujiSyuku.regular
        case .mPlus: FontFamily.MPlus2.regular
        }
    }

    public static let defaultFamily: CustomFontFamily = .mPlus
}

public extension View {
    func typography(_ typography: Typography, fontFamily: CustomFontFamily = .defaultFamily) -> some View {
        modifier(TypographyModifier(typography: typography, fontFamily: fontFamily))
    }
}
