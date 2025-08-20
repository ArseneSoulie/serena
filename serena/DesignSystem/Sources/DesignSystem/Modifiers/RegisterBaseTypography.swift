import SwiftUI

@MainActor
public func registerFontForUIKitComponents() {
    let fontConvertible = CustomFontFamily.defaultFamily.fontConvertible

    let largeNavBarFont = fontConvertible.font(typography: .title2)
    let navBarFont = fontConvertible.font(typography: .headline)
    let buttonFont = fontConvertible.font(typography: .body)
    let tabBarFont = fontConvertible.font(typography: .caption)
    let segmentedControlFont = fontConvertible.font(typography: .caption)

    let navBarAppearance = UINavigationBarAppearance()
    let buttonAppearance = UIBarButtonItemAppearance()

    navBarAppearance.largeTitleTextAttributes = [.font: largeNavBarFont]
    navBarAppearance.titleTextAttributes = [.font: navBarFont]

    buttonAppearance.normal.titleTextAttributes = [.font: buttonFont]
    navBarAppearance.buttonAppearance = buttonAppearance

    UINavigationBar.appearance().standardAppearance = navBarAppearance

    UITabBarItem.appearance().setTitleTextAttributes([.font: tabBarFont], for: .normal)

    UISegmentedControl.appearance().setTitleTextAttributes([.font: segmentedControlFont], for: .normal)
}

public extension View {
    func registerFontForSwiftUIComponents() -> some View {
        modifier(RegisterSwiftUIFontsModifier())
    }
}

struct RegisterSwiftUIFontsModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .environment(\.font, Typography.defaultFont)
            .font(Typography.defaultFont)
    }
}
